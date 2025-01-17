namespace CatlikeCodingFS.Basics1

open Godot

type TransitionMode =
    | Cycle = 0
    | Random = 1

[<AbstractClass>]
type GraphFS() =
    inherit Node3D()

    let mutable points: CsgBox3D array = null
    // 切记：对于 Tool 的 _Process 必须引入一个 bool 变量用 if 分支控制编译中间、之后都不报错
    let mutable ready = false
    let mutable duration = 0f
    let mutable transitioning = false
    let mutable transitionFunction = FunctionLibrary.FunctionName.Wave
    let mutable multiMeshIns: MultiMeshInstance3D = null

    abstract PointPrefab: PackedScene with get, set
    abstract UseMultiMesh: bool with get, set
    abstract Resolution: int with get, set
    abstract Function: FunctionLibrary.FunctionName with get, set
    abstract FunctionDuration: float32 with get, set
    abstract TransitionDuration: float32 with get, set
    abstract TransitionMode: TransitionMode with get, set

    member this.InitBySceneIns() =
        if this.PointPrefab <> null then
            let step = 2f / float32 this.Resolution
            let scale = Vector3.One * step
            points <- Array.zeroCreate <| this.Resolution * this.Resolution

            for i in 0 .. points.Length - 1 do
                let point = this.PointPrefab.Instantiate<CsgBox3D>()
                points[i] <- point
                point.Scale <- scale
                this.AddChild(point)

        // 清理多网格实例
        if multiMeshIns <> null && multiMeshIns.Multimesh <> null then
            multiMeshIns.Multimesh.InstanceCount <- 0

    member this.InitByMultiMesh() =
        if multiMeshIns <> null && multiMeshIns.Multimesh <> null then
            let step = 2f / float32 this.Resolution
            let scale = Vector3.One * step
            let count = this.Resolution * this.Resolution
            multiMeshIns.Multimesh.InstanceCount <- count

            if count > 0 then
                for i in 0 .. count - 1 do
                    multiMeshIns.Multimesh.SetInstanceTransform(
                        i,
                        Transform3D(Basis.Identity.Scaled scale, Vector3.Zero)
                    )

        // 清理场景实例
        if points <> null then
            for point in points do
                point.QueueFree()

        points <- null

    member this.InitGraph() =
        if ready then
            if this.UseMultiMesh then
                if multiMeshIns <> null then
                    multiMeshIns.Visible <- true
                    this.InitByMultiMesh()
            else if multiMeshIns <> null then
                multiMeshIns.Visible <- false
                this.InitBySceneIns()

    member this.UpdateFunctionTransition() =
        let fromF = FunctionLibrary.getFunction transitionFunction
        let toF = FunctionLibrary.getFunction this.Function
        let progress = duration / this.TransitionDuration
        let time = float32 (Time.GetTicksMsec()) / 1000f
        let step = 2f / float32 this.Resolution
        let scale = Vector3.One * step
        let count = this.Resolution * this.Resolution

        let functionTransition =
            if transitioning then
                fromF
            else
                fun u v t -> FunctionLibrary.morph u v t fromF toF progress

        let update =
            if this.UseMultiMesh then
                if multiMeshIns <> null && multiMeshIns.Multimesh <> null then
                    fun i u v t ->
                        multiMeshIns.Multimesh.SetInstanceTransform(
                            i,
                            Transform3D(Basis.Identity.Scaled scale, functionTransition u v t)
                        )
                else
                    fun _ _ _ _ -> ()
            else
                fun i u v t ->
                    let point = points[i]
                    point.Position <- functionTransition u v t

        let mutable x = 0
        let mutable z = 0
        let mutable v = 0.5f * step - 1f

        for i in 0 .. count - 1 do
            if x = this.Resolution then
                x <- 0
                z <- z + 1
                v <- (float32 z + 0.5f) * step - 1f

            let u = (float32 x + 0.5f) * step - 1f
            update i u v time
            x <- x + 1

    member this.PickNextFunction() =
        this.Function <-
            match this.TransitionMode with
            | TransitionMode.Cycle -> FunctionLibrary.getNextFunctionName this.Function
            | _ -> FunctionLibrary.getRandomFunctionNameOtherThan this.Function

    override this._Ready() =
        // 必须在代码里初始化 MultiMeshInstance3D 节点，不然场景里面既有的节点会被持久化
        // 否则 .tscn 将会包含了那些变化的 Transform 数组，一方面会很大，而且另一方面每次运行后都会被更新。其实完全没必要保存
        // （此外还少了一个 Godot 4.3 /scene/resources/multimesh.cpp:309 ERR_FAIL_COND(instance_count > 0); 的报错）
        multiMeshIns <- new MultiMeshInstance3D()
        multiMeshIns.Multimesh <- new MultiMesh()
        multiMeshIns.Multimesh.SetTransformFormat(MultiMesh.TransformFormatEnum.Transform3D)
        multiMeshIns.Multimesh.Mesh <- GD.Load<BoxMesh>("res://Materials/Basics1/GraphPointMesh.tres")
        this.AddChild(multiMeshIns)
        ready <- true
        this.InitGraph()

    override this._Process delta =
        if ready then
            duration <- duration + float32 delta

            if transitioning then
                if duration >= this.TransitionDuration then
                    duration <- duration - this.TransitionDuration
                    transitioning <- false
            elif duration >= this.FunctionDuration then
                duration <- duration - this.FunctionDuration
                transitioning <- true
                transitionFunction <- this.Function
                this.PickNextFunction()

            this.UpdateFunctionTransition()
