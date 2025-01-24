namespace CatlikeCodingFS.Movement6

open Godot

[<AbstractClass>]
type GravitySphereFS() =
    inherit GravitySourceFS()

    let mutable outerFalloffFactor = 0f
    let mutable innerFalloffFactor = 0f

    abstract Gravity: float32 with get, set // = 9.81f
    abstract OuterRadius: float32 with get, set // = 10f (min 0f)
    abstract OuterFalloffRadius: float32 with get, set // = 15f (min 0f)
    abstract InnerRadius: float32 with get, set // = 5f (min 0f)
    abstract InnerFalloffRadius: float32 with get, set // = 1f (min 0f)

    interface IGravitySource with
        override this.GetGravity(position: Vector3) =
            let vector = this.GlobalPosition - position
            let distance = vector.Length()

            if distance > this.OuterFalloffRadius || distance < this.InnerFalloffRadius then
                Vector3.Zero
            else
                let mutable g = this.Gravity / distance

                if distance > this.OuterRadius then
                    g <- g * (1f - (distance - this.OuterRadius) * outerFalloffFactor)
                elif distance < this.InnerRadius then
                    g <- g * (1f - (this.InnerRadius - distance) * innerFalloffFactor)

                g * vector

    member this.OnValidate() =
        this.InnerFalloffRadius <- Mathf.Max(this.InnerFalloffRadius, 0f)
        this.InnerRadius <- Mathf.Max(this.InnerRadius, this.InnerFalloffRadius)
        this.OuterRadius <- Mathf.Max(this.InnerRadius, this.OuterRadius)
        this.OuterFalloffRadius <- Mathf.Max(this.OuterRadius, this.OuterFalloffRadius)
        innerFalloffFactor <- 1f / (this.InnerRadius - this.InnerFalloffRadius)
        outerFalloffFactor <- 1f / (this.OuterFalloffRadius - this.OuterRadius)

    member this.GizmosDrawSphere radius (color: Color) =
        let meshIns = new MeshInstance3D()
        let mesh = new SphereMesh()
        mesh.Radius <- radius
        mesh.Height <- radius * 2f
        let material = new StandardMaterial3D()
        material.Transparency <- BaseMaterial3D.TransparencyEnum.Alpha
        material.AlbedoColor <- color
        mesh.Material <- material
        meshIns.Mesh <- mesh
        this.AddChild meshIns

    override this._Ready() =
        base._Ready ()
        this.OnValidate()

        if this.InnerFalloffRadius > 0f && this.InnerFalloffRadius < this.InnerRadius then
            let mutable cyan = Colors.Cyan
            cyan.A <- 0.3f
            this.GizmosDrawSphere this.InnerFalloffRadius cyan

        let mutable yellow = Colors.Yellow
        yellow.A <- 0.3f

        if this.InnerRadius > 0f && this.InnerRadius < this.OuterRadius then
            this.GizmosDrawSphere this.InnerRadius yellow

        this.GizmosDrawSphere this.OuterRadius yellow

        if this.OuterFalloffRadius > this.OuterRadius then
            let mutable cyan = Colors.Cyan
            cyan.A <- 0.3f
            this.GizmosDrawSphere this.OuterFalloffRadius cyan

        GD.Print "GravitySphere Ready"
