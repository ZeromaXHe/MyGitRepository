namespace CatlikeCodingFS.Basics1

open Godot

[<AbstractClass>]
type GraphFS() =
    inherit Node3D()

    let mutable points: CsgBox3D array = null
    // 切记：对于 Tool 的 _Process 必须引入一个 bool 变量用 if 分支控制编译中间、之后都不报错
    let mutable ready = false

    abstract PointPrefab: PackedScene with get, set
    abstract Resolution: int with get, set
    abstract Function: FunctionLibrary.FunctionName with get, set

    override this._Ready() =
        if this.PointPrefab <> null then
            let step = 2f / float32 this.Resolution
            let scale = Vector3.One * step
            points <- Array.zeroCreate <| this.Resolution * this.Resolution

            for i in 0 .. points.Length - 1 do
                let point = this.PointPrefab.Instantiate<CsgBox3D>()
                points[i] <- point
                point.Scale <- scale
                this.AddChild(point)

        ready <- true

    override this._Process _ =
        if ready then
            let f = FunctionLibrary.getFunction this.Function
            let time = float32 (Time.GetTicksMsec()) / 1000f
            let step = 2f / float32 this.Resolution

            let mutable x = 0
            let mutable z = 0
            let mutable v = 0.5f * step - 1f

            for point in points do
                if x = this.Resolution then
                    x <- 0
                    z <- z + 1
                    v <- (float32 z + 0.5f) * step - 1f

                let u = (float32 x + 0.5f) * step - 1f
                point.Position <- f u v time
                x <- x + 1
