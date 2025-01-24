namespace CatlikeCodingFS.Movement6

open Godot

[<AbstractClass>]
type GravityBoxFS() =
    inherit GravitySourceFS()

    let mutable innerFalloffFactor = 0f
    let mutable outerFalloffFactor = 0f

    abstract Gravity: float32 with get, set // = 9.81f
    abstract BoundaryDistance: Vector3 with get, set // = Vector3.One
    abstract InnerDistance: float32 with get, set // = 0f (min 0f)
    abstract InnerFalloffDistance: float32 with get, set // = 0f (min 0f)
    abstract OuterDistance: float32 with get, set // = 0f (min 0f)
    abstract OuterFalloffDistance: float32 with get, set // = 0f (min 0f)

    member this.OnValidate() =
        let mutable vec =
            Vector3(
                Mathf.Max(this.BoundaryDistance.X, 0f),
                Mathf.Max(this.BoundaryDistance.Y, 0f),
                Mathf.Max(this.BoundaryDistance.Z, 0f)
            )

        this.BoundaryDistance <- vec

        let maxInner =
            Mathf.Min(Mathf.Min(this.BoundaryDistance.X, this.BoundaryDistance.Y), this.BoundaryDistance.Z)

        this.InnerDistance <- Mathf.Min(this.InnerDistance, maxInner)
        this.InnerFalloffDistance <- Mathf.Max(Mathf.Min(this.InnerFalloffDistance, maxInner), this.InnerDistance)
        this.OuterFalloffDistance <- Mathf.Max(this.OuterFalloffDistance, this.OuterDistance)
        innerFalloffFactor <- 1f / (this.InnerFalloffDistance - this.InnerDistance)
        outerFalloffFactor <- 1f / (this.OuterFalloffDistance - this.OuterDistance)

    member this.GetGravityComponent coordinate distance =
        if distance > this.InnerFalloffDistance then
            0f
        else
            let mutable g = this.Gravity

            if distance > this.InnerDistance then
                g <- g * (1f - (distance - this.InnerDistance) * innerFalloffFactor)

            if coordinate > 0f then -g else g

    interface IGravitySource with
        override this.GetGravity(position: Vector3) =
            let position = this.ToLocal(position - this.GlobalPosition)
            let mutable vector = Vector3.Zero
            let mutable outside = 0

            if position.X > this.BoundaryDistance.X then
                vector.X <- this.BoundaryDistance.X - position.X
                outside <- 1
            elif position.X < -this.BoundaryDistance.X then
                vector.X <- -this.BoundaryDistance.X - position.X
                outside <- 1

            if position.Y > this.BoundaryDistance.Y then
                vector.Y <- this.BoundaryDistance.Y - position.Y
                outside <- outside + 1
            elif position.Y < -this.BoundaryDistance.Y then
                vector.Y <- -this.BoundaryDistance.Y - position.Y
                outside <- outside + 1

            if position.Z > this.BoundaryDistance.Z then
                vector.Z <- this.BoundaryDistance.Z - position.Z
                outside <- outside + 1
            elif position.Z < -this.BoundaryDistance.Z then
                vector.Z <- -this.BoundaryDistance.Z - position.Z
                outside <- outside + 1

            if outside > 0 then
                let distance =
                    if outside = 1 then
                        Mathf.Abs(vector.X + vector.Y + vector.Z)
                    else
                        vector.Length()

                if distance > this.OuterFalloffDistance then
                    Vector3.Zero
                else
                    let mutable g = this.Gravity / distance

                    if distance > this.OuterDistance then
                        g <- g * (1f - (distance - this.OuterDistance) * outerFalloffFactor)

                    // GD.Print $"box out g: {this.ToGlobal(g * vector)}"
                    this.ToGlobal(g * vector)
            else
                let distances =
                    Vector3(
                        this.BoundaryDistance.X - Mathf.Abs position.X,
                        this.BoundaryDistance.Y - Mathf.Abs position.Y,
                        this.BoundaryDistance.Z - Mathf.Abs position.Z
                    )

                if distances.X < distances.Y then
                    if distances.X < distances.Z then
                        vector.X <- this.GetGravityComponent position.X distances.X
                    else
                        vector.Z <- this.GetGravityComponent position.Z distances.Z
                elif distances.Y < distances.Z then
                    vector.Y <- this.GetGravityComponent position.Y distances.Y
                else
                    vector.Z <- this.GetGravityComponent position.Z distances.Z

                // GD.Print $"box in g: {this.ToGlobal vector}"
                this.ToGlobal vector

    member this.GizmosDrawCube size (color: Color) =
        let meshIns = new MeshInstance3D()
        let mesh = new BoxMesh()
        let material = new StandardMaterial3D()
        material.Transparency <- BaseMaterial3D.TransparencyEnum.Alpha
        material.AlbedoColor <- color
        mesh.Material <- material
        meshIns.Mesh <- mesh
        meshIns.Scale <- size
        this.AddChild meshIns

    override this._Ready() =
        base._Ready ()
        this.OnValidate()

        if this.InnerFalloffDistance > this.InnerDistance then
            let mutable cyan = Colors.Cyan
            cyan.A <- 0.3f

            let sizeCyan =
                Vector3(
                    2f * (this.BoundaryDistance.X - this.InnerFalloffDistance),
                    2f * (this.BoundaryDistance.Y - this.InnerFalloffDistance),
                    2f * (this.BoundaryDistance.Z - this.InnerFalloffDistance)
                )

            this.GizmosDrawCube sizeCyan cyan

        if this.InnerDistance > 0f then
            let mutable yellow = Colors.Yellow
            yellow.A <- 0.3f

            let sizeYellow =
                Vector3(
                    2f * (this.BoundaryDistance.X - this.InnerDistance),
                    2f * (this.BoundaryDistance.Y - this.InnerDistance),
                    2f * (this.BoundaryDistance.Z - this.InnerDistance)
                )

            this.GizmosDrawCube sizeYellow yellow

        let mutable red = Colors.Red
        red.A <- 0.3f
        this.GizmosDrawCube (this.BoundaryDistance * 2f) red
        GD.Print "GravityBox Ready"
