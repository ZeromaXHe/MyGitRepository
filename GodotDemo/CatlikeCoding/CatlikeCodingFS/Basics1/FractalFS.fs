namespace CatlikeCodingFS.Basics1

open Godot

type FractalPart =
    struct
        val mutable worldPosition: Vector3
        val mutable rotation: Quaternion
        val mutable worldRotation: Quaternion
        val mutable spinAngle: float32
        val mutable maxSagAngle: float32
        val mutable spinVelocity: float32

        new(rotation, maxSagAngle, spinVelocity) =
            { worldPosition = Vector3.Zero
              rotation = rotation
              worldRotation = Quaternion.Identity
              spinAngle = 0f
              maxSagAngle = maxSagAngle
              spinVelocity = spinVelocity }
    end

[<AbstractClass>]
type FractalFS() =
    inherit Node3D()

    // 这里的 rotations 是四元数！一开始以为是 Vector3…… 然后用 Rotation 修改旋转就各种 bug 调了一下午
    let rotations =
        [| Quaternion.Identity
           Quaternion.FromEuler <| Vector3(0f, 0f, Mathf.DegToRad -90f)
           Quaternion.FromEuler <| Vector3(0f, 0f, Mathf.DegToRad 90f)
           Quaternion.FromEuler <| Vector3(Mathf.DegToRad 90f, 0f, 0f)
           Quaternion.FromEuler <| Vector3(Mathf.DegToRad -90f, 0f, 0f) |]

    let mutable parts: FractalPart array array = null
    let mutable matrices: Transform3D array array = null
    let mutable matricesBuffer: float32 array = null
    let mutable matricesBufferLeaves: float32 array = null
    let stride = 16 // 12 Transform + 4 Color
    let mutable sequenceNumbers: Vector4 array = null

    let mutable ready = false
    let mutable multiMeshIns: MultiMeshInstance3D = null
    let mutable multiMeshInsLeaves: MultiMeshInstance3D = null

    abstract Depth: int with get, set
    abstract MeshF: Mesh with get, set
    abstract LeafMesh: Mesh with get, set
    abstract MaterialF: Material with get, set
    abstract GradientA: Gradient with get, set
    abstract GradientB: Gradient with get, set
    abstract LeafColorA: Color with get, set
    abstract LeafColorB: Color with get, set
    abstract MaxSagAngleA: float32 with get, set
    abstract MaxSagAngleB: float32 with get, set
    abstract SpinSpeedA: float32 with get, set
    abstract SpinSpeedB: float32 with get, set
    abstract ReverseSpinChance: float32 with get, set

    member this.CreatePart childIndex =
        FractalPart(
            rotations[childIndex],
            Mathf.DegToRad(float32 (GD.RandRange(float this.MaxSagAngleA, float this.MaxSagAngleB))),
            (if GD.Randf() < this.ReverseSpinChance then -1f else 1f)
            * Mathf.DegToRad(float32 (GD.RandRange(float this.SpinSpeedA, float this.SpinSpeedB)))
        )

    member this.Transform3dToMatricesBuffer index li (transform: Transform3D) =
        let leafIndex = this.Depth - 1

        let buffer =
            if li = leafIndex then
                matricesBufferLeaves
            else
                matricesBuffer

        let idx =
            if li = leafIndex then
                index - matricesBuffer.Length / stride
            else
                index
        // 变换信息
        buffer[idx * stride] <- transform[0, 0]
        buffer[idx * stride + 1] <- transform[1, 0]
        buffer[idx * stride + 2] <- transform[2, 0]
        buffer[idx * stride + 3] <- transform[3, 0]
        buffer[idx * stride + 4] <- transform[0, 1]
        buffer[idx * stride + 5] <- transform[1, 1]
        buffer[idx * stride + 6] <- transform[2, 1]
        buffer[idx * stride + 7] <- transform[3, 1]
        buffer[idx * stride + 8] <- transform[0, 2]
        buffer[idx * stride + 9] <- transform[1, 2]
        buffer[idx * stride + 10] <- transform[2, 2]
        buffer[idx * stride + 11] <- transform[3, 2]
        // 颜色信息
        let color =
            if this.GradientA = null || this.GradientB = null then
                let offset = float32 li / float32 leafIndex
                Colors.Yellow.Lerp(Colors.Red, offset)
            else
                let colorA, colorB =
                    if li = leafIndex then
                        this.LeafColorA, this.LeafColorB
                    else
                        let gradientInterpolator = float32 li / float32 (this.Depth - 2)
                        this.GradientA.Sample(gradientInterpolator), this.GradientB.Sample(gradientInterpolator)

                let rand = (float32 idx * sequenceNumbers[li].X + sequenceNumbers[li].Y) % 1f
                colorA.Lerp(colorB, rand)

        buffer[idx * stride + 12] <- color.R
        buffer[idx * stride + 13] <- color.G
        buffer[idx * stride + 14] <- color.B
        buffer[idx * stride + 15] <- color.A

    override this._Ready() =
        parts <- Array.zeroCreate this.Depth
        matrices <- Array.zeroCreate this.Depth
        sequenceNumbers <- Array.zeroCreate this.Depth
        let mutable bufferSize = 0
        let mutable bufferSizeLeaves = 0
        let mutable length = 1

        for i in 0 .. parts.Length - 1 do
            parts[i] <- Array.zeroCreate length
            matrices[i] <- Array.zeroCreate length

            if i = parts.Length - 1 then
                bufferSizeLeaves <- bufferSizeLeaves + length * stride
            else
                bufferSize <- bufferSize + length * stride

            sequenceNumbers[i] <- Vector4(GD.Randf(), GD.Randf(), GD.Randf(), GD.Randf())
            length <- length * 5

        matricesBuffer <- Array.zeroCreate bufferSize
        matricesBufferLeaves <- Array.zeroCreate bufferSizeLeaves
        parts[0][0] <- this.CreatePart 0

        for li in 1 .. parts.Length - 1 do
            let levelParts = parts[li]

            for fpi in 0..5 .. levelParts.Length - 1 do // 两个 .. 的情况，中间值是 skip 值
                for ci in 0..4 do
                    levelParts[fpi + ci] <- this.CreatePart ci
        // 必须在代码里初始化 MultiMeshInstance3D 节点，不然场景里面既有的节点会被持久化
        // 否则 .tscn 将会包含了那些变化的 Transform 数组，一方面会很大，而且另一方面每次运行后都会被更新。其实完全没必要保存
        multiMeshIns <- new MultiMeshInstance3D()
        multiMeshIns.Multimesh <- new MultiMesh()
        multiMeshIns.Multimesh.SetTransformFormat(MultiMesh.TransformFormatEnum.Transform3D)
        multiMeshIns.Multimesh.Mesh <- this.MeshF
        (multiMeshIns.Multimesh.Mesh :?> PrimitiveMesh).Material <- this.MaterialF
        multiMeshIns.Multimesh.UseColors <- true
        multiMeshIns.Multimesh.InstanceCount <- bufferSize / stride
        this.AddChild multiMeshIns
        // 叶子多网格
        multiMeshInsLeaves <- new MultiMeshInstance3D()
        multiMeshInsLeaves.Multimesh <- new MultiMesh()
        multiMeshInsLeaves.Multimesh.SetTransformFormat(MultiMesh.TransformFormatEnum.Transform3D)
        multiMeshInsLeaves.Multimesh.Mesh <- this.LeafMesh
        (multiMeshInsLeaves.Multimesh.Mesh :?> PrimitiveMesh).Material <- this.MaterialF
        multiMeshInsLeaves.Multimesh.UseColors <- true
        multiMeshInsLeaves.Multimesh.InstanceCount <- bufferSizeLeaves / stride
        this.AddChild multiMeshInsLeaves

        ready <- true

    override this._Process(delta) =
        if ready then
            let mutable rootPart = parts[0][0]
            rootPart.spinAngle <- rootPart.spinAngle + rootPart.spinVelocity * float32 delta
            // 不然运行久了浮点数精度不够，Quaternion 不再是 Normalized，乘法报错
            if rootPart.spinAngle > Mathf.Pi * 2f then
                rootPart.spinAngle <- rootPart.spinAngle - Mathf.Pi * 2f
            // 注意是修改 Quaternion 四元数，3D 不推荐修改 Rotation 旋转
            // Quaternion 需要 Normalized()，不然运行久了浮点数精度不够，赋值给 Transform3D 报错
            rootPart.worldRotation <-
                (this.Quaternion
                 * (rootPart.rotation * Quaternion.FromEuler(Vector3(0f, rootPart.spinAngle, 0f))))
                    .Normalized()

            rootPart.worldPosition <- this.Position

            parts[0][0] <- rootPart
            matrices[0][0] <- Transform3D(Basis(rootPart.worldRotation).Scaled Vector3.One, rootPart.worldPosition)
            this.Transform3dToMatricesBuffer 0 0 (matrices[0][0])
            let mutable scale = 1f
            let mutable idx = 1

            for li in 1 .. parts.Length - 1 do
                scale <- scale * 0.5f
                let parentParts = parts[li - 1]
                let levelParts = parts[li]
                let levelMatrices = matrices[li]

                for fpi in 0 .. levelParts.Length - 1 do
                    let parent = parentParts[fpi / 5]
                    let mutable part = levelParts[fpi]
                    part.spinAngle <- part.spinAngle + part.spinVelocity * float32 delta
                    // 不然运行久了浮点数精度不够，Quaternion 不再是 Normalized，乘法报错
                    if part.spinAngle > Mathf.Pi * 2f then
                        part.spinAngle <- part.spinAngle - Mathf.Pi * 2f

                    let upAxis = (parent.worldRotation * part.rotation) * Vector3.Up
                    let sagAxis = Vector3.Up.Cross(upAxis)
                    let sagMagnitude = sagAxis.Length()

                    let baseRotation =
                        if sagMagnitude > 0f then
                            let sagAxis = sagAxis / sagMagnitude
                            let sagRotation = Quaternion(sagAxis, part.maxSagAngle * sagMagnitude)
                            sagRotation * parent.worldRotation
                        else
                            parent.worldRotation
                    // 注意是修改 Quaternion 四元数，3D 不推荐修改 Rotation 旋转
                    // Quaternion 需要 Normalized()，不然运行久了浮点数精度不够，赋值给 Transform3D 报错
                    part.worldRotation <-
                        (baseRotation
                         * (part.rotation * Quaternion.FromEuler(Vector3(0f, part.spinAngle, 0f))))
                            .Normalized()

                    part.worldPosition <- parent.worldPosition + part.worldRotation * Vector3(0f, 1.5f * scale, 0f)
                    levelParts[fpi] <- part

                    levelMatrices[fpi] <-
                        Transform3D(Basis(part.worldRotation).Scaled(Vector3.One * scale), part.worldPosition)

                    this.Transform3dToMatricesBuffer idx li levelMatrices[fpi]
                    idx <- idx + 1

            RenderingServer.MultimeshSetBuffer(multiMeshIns.Multimesh.GetRid(), matricesBuffer)
            RenderingServer.MultimeshSetBuffer(multiMeshInsLeaves.Multimesh.GetRid(), matricesBufferLeaves)
