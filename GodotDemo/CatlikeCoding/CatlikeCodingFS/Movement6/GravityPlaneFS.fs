namespace CatlikeCodingFS.Movement6

open Godot

[<AbstractClass>]
type GravityPlaneFS() =
    inherit GravitySourceFS()

    abstract Gravity: float32 with get, set // = 9.81f
    abstract Range: float32 with get, set // = 1f (min 0f)

    interface IGravitySource with
        override this.GetGravity(position: Vector3) =
            let up = this.Quaternion * Vector3.Up
            let distance = up.Dot(position - this.GlobalPosition)

            if distance > this.Range then
                Vector3.Zero
            else
                let mutable g = -this.Gravity

                if distance > 0f then
                    g <- g * (1f - distance / this.Range)

                g * up

    override this._Ready() =
        base._Ready ()
        let mutable scale = this.Scale
        scale.Y <- this.Range

        let meshInsYellow = new MeshInstance3D()
        let meshYellow = new PlaneMesh()
        let materialYellow = new StandardMaterial3D()
        let mutable yellow = Colors.Yellow
        yellow.A <- 0.3f
        materialYellow.Transparency <- BaseMaterial3D.TransparencyEnum.Alpha
        materialYellow.AlbedoColor <- yellow
        meshYellow.Material <- materialYellow
        meshInsYellow.Mesh <- new PlaneMesh()
        meshInsYellow.Scale <- scale

        if this.Range > 0f then
            let meshInsCyan = new MeshInstance3D()
            let meshCyan = new PlaneMesh()
            let materialCyan = new StandardMaterial3D()
            let mutable cyan = Colors.Cyan
            cyan.A <- 0.3f
            materialCyan.Transparency <- BaseMaterial3D.TransparencyEnum.Alpha
            materialCyan.AlbedoColor <- cyan
            meshCyan.Material <- materialCyan
            meshInsCyan.Mesh <- new PlaneMesh()
            meshInsCyan.Position <- Vector3.Up * this.Range
            meshInsCyan.Scale <- scale
            this.AddChild meshInsCyan
