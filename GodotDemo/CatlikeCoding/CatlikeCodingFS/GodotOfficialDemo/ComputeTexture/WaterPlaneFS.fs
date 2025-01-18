namespace CatlikeCodingFS.GodotOfficialDemo.ComputeTexture

open System
open Godot
open Godot.Collections

[<AbstractClass>]
type WaterPlaneFS() =
    inherit Area3D()

    let mutable t = 0f
    let mutable maxT = 0.1f
    let mutable texture: Texture2Drd = null
    let mutable nextTexture = 0
    let mutable addWavePoint = Vector4.Zero
    let mutable mousePos = Vector2.Zero
    let mutable mousePressed = false

    let mutable rd: RenderingDevice = null
    let mutable shader = Rid()
    let mutable pipeline = Rid()
    // 我们使用 3 个纹理：
    // - 一个被渲染（one to render into）
    // - 一个包含最后的渲染帧
    // - 一个为前者的前一帧
    let mutable textureRds = [| Rid(); Rid(); Rid() |]
    let mutable textureSets = [| Rid(); Rid(); Rid() |]

    let mutable ready = false

    abstract RainSize: float32 with get, set
    abstract MouseSize: float32 with get, set
    abstract TextureSize: Vector2I with get, set
    abstract Damp: float32 with get, set

    member this.CreateUniformSet(textureRd: Rid) =
        let uniform = new RDUniform()
        uniform.UniformType <- RenderingDevice.UniformType.Image
        uniform.Binding <- 0
        uniform.AddId textureRd
        // 即使我们使用了 3 个集，它们是相同的，所以我们有点作弊
        rd.UniformSetCreate(Array<RDUniform>([| uniform |]), shader, 0u)

    member this.InitializeComputeCode(initWithTextureSize: Vector2I) =
        // 因为这作为我们法线帧渲染（normal frame rendering）的一部分，我们在这里使用我们的主渲染设备
        rd <- RenderingServer.GetRenderingDevice() // 不是 CreateLocal 而是 Get！
        // 创建我们的着色器
        let shaderFile =
            GD.Load("res://Shaders/GodotOfficialDemo/ComputeTexture/water_compute.glsl") :?> RDShaderFile

        let shaderSpirV = shaderFile.GetSpirV()
        shader <- rd.ShaderCreateFromSpirV shaderSpirV
        pipeline <- rd.ComputePipelineCreate shader
        // 创建我们的纹理来管理我们的波浪
        let tf = new RDTextureFormat()
        tf.Format <- RenderingDevice.DataFormat.R32Sfloat
        tf.TextureType <- RenderingDevice.TextureType.Type2D
        tf.Width <- uint initWithTextureSize.X
        tf.Height <- uint initWithTextureSize.Y
        tf.Depth <- 1u
        tf.ArrayLayers <- 1u
        tf.Mipmaps <- 1u

        tf.UsageBits <-
            RenderingDevice.TextureUsageBits.SamplingBit
            ||| RenderingDevice.TextureUsageBits.ColorAttachmentBit
            ||| RenderingDevice.TextureUsageBits.StorageBit
            ||| RenderingDevice.TextureUsageBits.CanUpdateBit
            ||| RenderingDevice.TextureUsageBits.CanCopyToBit

        for i in 0..2 do
            // 创建我们的纹理
            textureRds[i] <- rd.TextureCreate(tf, new RDTextureView())
            // 确保我们纹理被清空
            rd.TextureClear(textureRds[i], Color(0f, 0f, 0f, 0f), 0u, 1u, 0u, 1u) |> ignore
            // 现在创建我们的 uniform 集，这样我们可以在我们的着色器中使用这些纹理
            textureSets[i] <- this.CreateUniformSet(textureRds[i])

    override this._Ready() =
        // 因为我们在渲染线程上运行各种东西，我们也需要在那个线程上初始化
        RenderingServer.CallOnRenderThread
        <| Callable.From(fun () -> this.InitializeComputeCode this.TextureSize)
        // 从我们的材质中获取我们纹理
        let material =
            (this.GetNode<MeshInstance3D> "MeshInstance3D").MaterialOverride :?> ShaderMaterial
        // 我不理解为啥这个 ShaderMaterial 必须设置 resource_local_to_scene = true，否则在编辑器中 ComputeTexture.tscn 没反应
        // 而且目前在两个编辑器场景切换时，一定会报错，切换后必须“重载已保存场景”才能正常。(官方示例就是这样……)
        if material <> null then
            material.SetShaderParameter("effect_texture_size", this.TextureSize)
            // 获取我们的纹理对象
            texture <- (material.GetShaderParameter "effect_texture").As<Texture2Drd>()

        ready <- true

    member this.FreeComputeResources() =
        // 注意到我们集和流水线被自动清理干净，因为它们是依赖 :P
        for i in 0..2 do
            if textureRds[i] <> Rid() then
                rd.FreeRid textureRds[i]

        if shader <> Rid() then
            rd.FreeRid shader

    override this._ExitTree() =
        // 确保我们清理干净！
        if texture <> null then
            texture.TextureRdRid <- Rid()

        RenderingServer.CallOnRenderThread <| Callable.From this.FreeComputeResources

    override this._UnhandledInput(event) =
        // 如果工具模式被激活，则我们不需要处理编辑器中的输入
        if Engine.IsEditorHint() then
            ()
        else
            if event :? InputEventMouseMotion || event :? InputEventMouseButton then
                let e = event :?> InputEventMouse
                mousePos <- e.GlobalPosition

            if event :? InputEventMouseButton then
                let e = event :?> InputEventMouseButton

                if e.ButtonIndex = MouseButton.Left then
                    mousePressed <- e.Pressed

    member this.CheckMousePos() =
        // 这是一个鼠标事件，做一个 raycast
        let camera = this.GetViewport().GetCamera3D()
        let parameters = new PhysicsRayQueryParameters3D()
        parameters.From <- camera.ProjectRayOrigin mousePos
        parameters.To <- parameters.From + (camera.ProjectRayNormal mousePos) * 100f
        parameters.CollisionMask <- 1u
        parameters.CollideWithBodies <- false
        parameters.CollideWithAreas <- true
        let result = this.GetWorld3D().DirectSpaceState.IntersectRay parameters

        if result.Count > 0 then
            // 变换我们的交点
            let pos = this.GlobalTransform.AffineInverse() * result["position"].As<Vector3>()

            addWavePoint.X <-
                Mathf.Clamp(pos.X / 5f, -0.5f, 0.5f) * float32 this.TextureSize.X
                + 0.5f * float32 this.TextureSize.X

            addWavePoint.Y <-
                Mathf.Clamp(pos.Z / 5f, -0.5f, 0.5f) * float32 this.TextureSize.Y
                + 0.5f * float32 this.TextureSize.Y
            // 我们剩下了 w，所以我们使用它来指示鼠标在我们水平面上
            addWavePoint.W <- 1f
        else
            addWavePoint.X <- 0f
            addWavePoint.Y <- 0f
            addWavePoint.W <- 0f

    member this.RenderProcess withNextTexture (wavePoint: Vector4) (texSize: Vector2I) pDamp =
        // 我们没有结构，所以我们需要用“困难方法”构建我们的推送常数
        let pushConstant =
            [| wavePoint.X
               wavePoint.Y
               wavePoint.Z
               wavePoint.W
               float32 texSize.X
               float32 texSize.Y
               pDamp
               0f |]
        // 计算我们的分发组大小
        // 我们做 `n - 1 / 8 + 1` 防止我们纹理大小不能恰好被 8 整除
        //
        let xGroups = (texSize.X - 1) / 8 + 1
        let yGroups = (texSize.Y - 1) / 8 + 1
        let nextSet = textureSets[withNextTexture]
        let currentSet = textureSets[(withNextTexture + 2) % 3]
        let previousSet = textureSets[(withNextTexture + 1) % 3]
        // 运行我们计算着色器
        let computeList = rd.ComputeListBegin()
        rd.ComputeListBindComputePipeline(computeList, pipeline)
        rd.ComputeListBindUniformSet(computeList, currentSet, 0u)
        rd.ComputeListBindUniformSet(computeList, previousSet, 1u)
        rd.ComputeListBindUniformSet(computeList, nextSet, 2u)

        let pushConstantBytes =
            Array.zeroCreate<byte> <| pushConstant.Length * sizeof<float32>

        Buffer.BlockCopy(pushConstant, 0, pushConstantBytes, 0, pushConstantBytes.Length)
        rd.ComputeListSetPushConstant(computeList, pushConstantBytes, uint pushConstantBytes.Length)
        rd.ComputeListDispatch(computeList, uint xGroups, uint yGroups, 1u)
        rd.ComputeListEnd()
        // 我们这里不需要同步，Godot 默认屏障会做这个技巧
        // 如果我们想要输出一个计算着色器来被作为另一个计算着色器的输入使用，你需要增加一个屏障：
        // rd.Barrier(RenderingDevice.BarrierMask.Compute) // 这个方法什么也不做。已被弃用：RenderingDevice 会自动插入屏障。
        ()

    override this._Process(delta) =
        if ready then
            // 如果工具模式启用，忽略鼠标输入
            if Engine.IsEditorHint() then
                addWavePoint.W <- 0f
            else
                // 检查我们鼠标和我们的区域相交于何处，如果事务变化则能够改变
                this.CheckMousePos()
            // 如果我们不使用鼠标，则生成动画水滴，我们（滥）用我们的 W 做这个
            if addWavePoint.W = 0f then
                t <- t + float32 delta

                if t > maxT then
                    t <- 0f
                    addWavePoint.X <- float32 <| GD.RandRange(0, this.TextureSize.X)
                    addWavePoint.Y <- float32 <| GD.RandRange(0, this.TextureSize.Y)
                    addWavePoint.Z <- this.RainSize
                else
                    addWavePoint.Z <- 0f
            else
                addWavePoint.Z <- if mousePressed then this.MouseSize else 0f
            // 增加我们下一个纹理索引
            nextTexture <- (nextTexture + 1) % 3
            // 更新我们纹理来展示我们下一个结果（我们将要创建的）。
            // 注意到 `InitializeComputeCode` 可能还没有运行，所以第一帧这可能是空 RID
            if texture <> null then
                texture.TextureRdRid <- textureRds[nextTexture]
            // 因为我们 RenderProcess 可能运行在渲染线程，所以它将在我们使用纹理前运行，
            // 因此我们的 nextRd 将被我们下一个结果填充。
            // 因为 TextureSize 和 Damp 这些是 static 的，作为参数发送它们可能是过分的（overkill），
            // 但我们因为进程可能并行运行，所以发送 addWavePoint
            // GD.Print $"{textureRds[nextTexture]}"
            RenderingServer.CallOnRenderThread
            <| Callable.From(fun () -> this.RenderProcess nextTexture addWavePoint this.TextureSize this.Damp)
