namespace CatlikeCodingFS.Basics1

open System
open Godot
open Godot.Collections

[<AbstractClass>]
type GpuGraphFS() =
    inherit Node3D()

    // 切记：对于 Tool 的 _Process 必须引入一个 bool 变量用 if 分支控制编译中间、之后都不报错
    let mutable ready = false
    let mutable duration = 0f
    let mutable transitioning = false
    let mutable transitionFunction = FunctionLibrary.FunctionName.Wave
    let mutable multiMeshIns: MultiMeshInstance3D = null
    let rd = RenderingServer.CreateLocalRenderingDevice()

    abstract Resolution: int with get, set
    abstract Function: FunctionLibrary.FunctionName with get, set
    abstract FunctionDuration: float32 with get, set
    abstract TransitionDuration: float32 with get, set
    abstract TransitionMode: TransitionMode with get, set

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

    member this.InitGraph() =
        if ready && multiMeshIns <> null then
            multiMeshIns.Visible <- true
            // this.InitByMultiMesh()

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

        let mutable x = 0
        let mutable z = 0
        let mutable v = 0.5f * step - 1f

        for i in 0 .. count - 1 do
            if x = this.Resolution then
                x <- 0
                z <- z + 1
                v <- (float32 z + 0.5f) * step - 1f

            let u = (float32 x + 0.5f) * step - 1f
            // if multiMeshIns <> null && multiMeshIns.Multimesh <> null then
            multiMeshIns.Multimesh.SetInstanceTransform(
                i,
                Transform3D(Basis.Identity.Scaled scale, functionTransition u v time)
            )

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
        this.AddChild multiMeshIns
        ready <- true

        // this.InitGraph()

        GD.Print "测试计算着色器，开始……"
        // 加载 GLSL 着色器
        let shaderFile =
            GD.Load("res://Shaders/Basics1/FunctionLibrary.glsl") :?> RDShaderFile

        let shaderSpirV = shaderFile.GetSpirV()
        let shader = rd.ShaderCreateFromSpirV shaderSpirV
        // 准备顶点字节数组，Vector3 数组被拆成 3 个 float32 数组，因为 Buffer.BlockCopy 只适用于基类数组。
        // （而且 ProceduralPlanet 那个项目在 GDScript 也是这样做的……）
        let count = this.Resolution * this.Resolution
        let vertices = Array.zeroCreate<float32> <| count * 3
        let verticesBytes = Array.zeroCreate<byte> <| vertices.Length * sizeof<float32>
        Buffer.BlockCopy(vertices, 0, verticesBytes, 0, verticesBytes.Length)
        // 准备 uint 参数数组
        let uintParams = [| uint this.Resolution; 0u |]
        let uintParamsBytes = Array.zeroCreate<byte> <| uintParams.Length * sizeof<uint>
        Buffer.BlockCopy(uintParams, 0, uintParamsBytes, 0, uintParamsBytes.Length)
        // 准备 float 参数数组
        let step = 2f / float32 this.Resolution
        let floatParams = [| step; 0f; 0f |]

        let floatParamsBytes =
            Array.zeroCreate<byte> <| floatParams.Length * sizeof<float32>

        Buffer.BlockCopy(floatParams, 0, floatParamsBytes, 0, floatParamsBytes.Length)

        // 创建顶点存储缓冲区
        let verticesBuffer =
            rd.StorageBufferCreate(uint verticesBytes.Length, verticesBytes)

        let uniformVertices = new RDUniform()
        uniformVertices.UniformType <- RenderingDevice.UniformType.StorageBuffer
        uniformVertices.Binding <- 0
        uniformVertices.AddId verticesBuffer
        // 创建 uint 参数存储缓冲区
        let uintParamsBuffer =
            rd.StorageBufferCreate(uint uintParamsBytes.Length, uintParamsBytes)

        let uniformUintParams = new RDUniform()
        uniformUintParams.UniformType <- RenderingDevice.UniformType.StorageBuffer
        uniformUintParams.Binding <- 1
        uniformUintParams.AddId uintParamsBuffer
        // 创建 float 参数存储缓冲区
        let floatParamsBuffer =
            rd.StorageBufferCreate(uint floatParamsBytes.Length, floatParamsBytes)

        let uniformFloatParams = new RDUniform()
        uniformFloatParams.UniformType <- RenderingDevice.UniformType.StorageBuffer
        uniformFloatParams.Binding <- 2
        uniformFloatParams.AddId floatParamsBuffer

        let uniformSet =
            rd.UniformSetCreate(
                Array<RDUniform>([| uniformVertices; uniformUintParams; uniformFloatParams |]),
                shader,
                0u
            )
        // 创建计算流水线
        let pipeline = rd.ComputePipelineCreate shader
        let computeList = rd.ComputeListBegin()
        rd.ComputeListBindComputePipeline(computeList, pipeline)
        rd.ComputeListBindUniformSet(computeList, uniformSet, 0u)
        // 计算被舍入划分到大小和计算着色器 local_size 一致的大小的工作组
        rd.ComputeListDispatch(
            computeList,
            uint <| Mathf.CeilToInt(float32 count / 8f),
            uint <| Mathf.CeilToInt(float32 count / 8f),
            1u
        )

        rd.ComputeListEnd()
        // 提交到 GPU 和等待同步
        rd.Submit()
        rd.Sync()

        let outputBytes = rd.BufferGetData verticesBuffer
        let output = Array.zeroCreate<float32> <| count * 3
        Buffer.BlockCopy(outputBytes, 0, output, 0, outputBytes.Length)

        if count > 0 then
            let scale = Vector3.One * step
            multiMeshIns.Multimesh.InstanceCount <- count

            for i in 0 .. count - 1 do
                let pos = Vector3(output[i * 3], output[i * 3 + 1], output[i * 3 + 2])
                multiMeshIns.Multimesh.SetInstanceTransform(i, Transform3D(Basis.Identity.Scaled scale, pos))

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

        // this.UpdateFunctionTransition()
        
