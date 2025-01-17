namespace CatlikeCodingFS.Basics1

open Godot

[<AbstractClass>]
type GraphFS() =
    inherit Node3D()

    let mutable points: CsgBox3D array = null

    abstract PointPrefab: PackedScene with get, set
    abstract Resolution: int with get, set

    override this._Ready() =
        if this.PointPrefab <> null then
            let step = 2f / float32 this.Resolution
            let mutable position = Vector3.Zero
            let scale = Vector3.One * step
            points <- Array.zeroCreate this.Resolution

            for i in 0 .. points.Length - 1 do
                let point = this.PointPrefab.Instantiate<CsgBox3D>()
                points[i] <- point
                position.X <- (float32 i + 0.5f) * step - 1f
                point.Position <- position
                point.Scale <- scale
                this.AddChild(point)

    override this._Process _ =
        let time = float32 (Time.GetTicksMsec()) / 1000f

        for point in points do
            let mutable position = point.Position
            position.Y <- Mathf.Sin(Mathf.Pi * position.X + time)
            point.Position <- position
