namespace CatlikeCodingFS.GodotOfficialDemo.CompositorEffectsPostProcessing

open System
open Godot
open Godot.Collections
open Microsoft.FSharp.Core

[<AbstractClass>]
type PostProcessGrayScaleFS() =
    inherit CompositorEffect()

    let mutable rd: RenderingDevice = null
    let mutable shader = Rid()
    let mutable pipeline = Rid()

    member this.InitializeCompute() =
        // 在初始化时编译我们着色器
        rd <- RenderingServer.GetRenderingDevice()

        if rd <> null then
            // 编译我们的着色器
            let shaderFile =
                GD.Load "res://Shaders/GodotOfficialDemo/CompositorEffectsPostProcessing/post_process_grayscale.glsl"
                :?> RDShaderFile

            let shaderSpirV = shaderFile.GetSpirV()
            shader <- rd.ShaderCreateFromSpirV shaderSpirV

            if shader.IsValid then
                pipeline <- rd.ComputePipelineCreate shader

    member this.Init() =
        this.EffectCallbackType <- CompositorEffect.EffectCallbackTypeEnum.PostTransparent
        rd <- RenderingServer.GetRenderingDevice()
        RenderingServer.CallOnRenderThread <| Callable.From this.InitializeCompute

    override this._Notification(what) =
        if what = 1 then // NOTIFICATION_PREDELETE
            if shader.IsValid then
                // 释放我们的着色器，也将释放 pipeline 这些依赖
                rd.FreeRid shader

    // 被渲染线程每一帧调用
    override this._RenderCallback(effectCallbackType, renderData) =
        if
            rd <> null
            && effectCallbackType = int CompositorEffect.EffectCallbackTypeEnum.PostTransparent
            && pipeline.IsValid
        then
            // 获取我们渲染场景缓冲区对象，这给了我们访问渲染着色器的通道
            // 注意到渲染器的不同实现因为需要类型转换
            let renderSceneBuffers = renderData.GetRenderSceneBuffers() :?> RenderSceneBuffersRD

            if renderSceneBuffers <> null then
                // 获取我们渲染器尺寸，这是 3D 渲染分辨率！
                let size = renderSceneBuffers.GetInternalSize()

                if size.X <> 0 || size.Y <> 0 then
                    // 我们能在此使用计算着色器
                    let xGroups = (size.X - 1) / 8 + 1
                    let yGroups = (size.Y - 1) / 8 + 1
                    let zGroups = 1
                    // 创建推送常量
                    // 必须对齐到 16 字节，并和着色器中定义的顺序保持一致
                    let pushConstant = [| float32 size.X; float32 size.Y; 0f; 0f |]

                    let pushConstantBytes =
                        Array.zeroCreate<byte> <| pushConstant.Length * sizeof<float32>

                    Buffer.BlockCopy(pushConstant, 0, pushConstantBytes, 0, pushConstantBytes.Length)

                    // 循环 views，防止我们在做常规渲染（stereo rendering）。如果这是 mono 的话，没有额外消耗
                    let viewCount = renderSceneBuffers.GetViewCount()

                    for view in 0u .. viewCount - 1u do
                        // 为我们颜色图片获取 RID，我们将从它读写
                        let inputImage = renderSceneBuffers.GetColorLayer view
                        // 创建一个 uniform 集，这将被缓存；如果我们 viewports 被改变，缓存将被清除
                        let uniform = new RDUniform()
                        uniform.UniformType <- RenderingDevice.UniformType.Image
                        uniform.Binding <- 0
                        uniform.AddId inputImage

                        let uniformSet =
                            UniformSetCacheRD.GetCache(shader, 0u, Array<RDUniform>([| uniform |]))
                        // 运行我们计算着色器
                        let computeList = rd.ComputeListBegin()
                        rd.ComputeListBindComputePipeline(computeList, pipeline)
                        rd.ComputeListBindUniformSet(computeList, uniformSet, 0u)
                        rd.ComputeListSetPushConstant(computeList, pushConstantBytes, uint pushConstant.Length * 4u)
                        rd.ComputeListDispatch(computeList, uint xGroups, uint yGroups, uint zGroups)
                        rd.ComputeListEnd()
