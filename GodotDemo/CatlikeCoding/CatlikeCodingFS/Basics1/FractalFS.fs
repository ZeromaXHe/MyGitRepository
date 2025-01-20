namespace CatlikeCodingFS.Basics1

open Godot

type FractalPart =
    struct
        val mutable direction: Vector3
        val mutable worldPosition: Vector3
        val mutable rotation: Quaternion
        val mutable worldRotation: Quaternion
        val mutable spinAngle: float32

        new(direction, rotation) =
            { direction = direction
              worldPosition = Vector3.Zero
              rotation = rotation
              worldRotation = Quaternion.Identity
              spinAngle = 0f }
    end

[<AbstractClass>]
type FractalFS() =
    inherit Node3D()

    let directions =
        // Godot 和 Unity 前后相反
        [| Vector3.Up; Vector3.Right; Vector3.Left; Vector3.Back; Vector3.Forward |]

    // 这里的 rotations 是四元数！一开始以为是 Vector3…… 然后用 Rotation 修改旋转就各种 bug 调了一下午
    let rotations =
        [| Quaternion.Identity
           Quaternion.FromEuler <| Vector3(0f, 0f, Mathf.DegToRad -90f)
           Quaternion.FromEuler <| Vector3(0f, 0f, Mathf.DegToRad 90f)
           Quaternion.FromEuler <| Vector3(Mathf.DegToRad 90f, 0f, 0f)
           Quaternion.FromEuler <| Vector3(Mathf.DegToRad -90f, 0f, 0f) |]

    let mutable parts: FractalPart array array = null
    let mutable matrices: Transform3D array array = null
    let mutable matricesBuffers: float32 array = null

    let mutable ready = false
    let mutable multiMeshIns: MultiMeshInstance3D = null

    abstract Depth: int with get, set
    abstract MeshF: Mesh with get, set
    abstract MaterialF: Material with get, set

    member this.CreatePart childIndex =
        FractalPart(directions[childIndex], rotations[childIndex])

    member this.Transform3dToMatricesBuffers idx (transform: Transform3D) =
        matricesBuffers[idx * 12] <- transform[0, 0]
        matricesBuffers[idx * 12 + 1] <- transform[1, 0]
        matricesBuffers[idx * 12 + 2] <- transform[2, 0]
        matricesBuffers[idx * 12 + 3] <- transform[3, 0]
        matricesBuffers[idx * 12 + 4] <- transform[0, 1]
        matricesBuffers[idx * 12 + 5] <- transform[1, 1]
        matricesBuffers[idx * 12 + 6] <- transform[2, 1]
        matricesBuffers[idx * 12 + 7] <- transform[3, 1]
        matricesBuffers[idx * 12 + 8] <- transform[0, 2]
        matricesBuffers[idx * 12 + 9] <- transform[1, 2]
        matricesBuffers[idx * 12 + 10] <- transform[2, 2]
        matricesBuffers[idx * 12 + 11] <- transform[3, 2]

    override this._Ready() =
        parts <- Array.zeroCreate this.Depth
        matrices <- Array.zeroCreate this.Depth
        let mutable bufferSize = 0
        let stride = 12
        let mutable length = 1

        for i in 0 .. parts.Length - 1 do
            parts[i] <- Array.zeroCreate length
            matrices[i] <- Array.zeroCreate length
            bufferSize <- bufferSize + length * stride
            length <- length * 5

        matricesBuffers <- Array.zeroCreate bufferSize
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
        (multiMeshIns.Multimesh.Mesh :?> SphereMesh).Material <- this.MaterialF
        multiMeshIns.Multimesh.InstanceCount <- bufferSize / stride
        this.AddChild multiMeshIns

        ready <- true

    override this._Process(delta) =
        if ready then
            let spinAngleDelta = Mathf.DegToRad 22.5f * float32 delta
            let mutable rootPart = parts[0][0]
            rootPart.spinAngle <- rootPart.spinAngle + spinAngleDelta
            // 不然运行久了浮点数精度不够，Quaternion 不再是 Normalized，乘法报错
            if rootPart.spinAngle > Mathf.Pi * 2f then
                rootPart.spinAngle <- rootPart.spinAngle - Mathf.Pi * 2f
            // 注意是修改 Quaternion 四元数，3D 不推荐修改 Rotation 旋转
            // Quaternion 需要 Normalized()，不然运行久了浮点数精度不够，赋值给 Transform3D 报错
            rootPart.worldRotation <-
                (rootPart.rotation * Quaternion.FromEuler(Vector3(0f, rootPart.spinAngle, 0f)))
                    .Normalized()

            parts[0][0] <- rootPart
            matrices[0][0] <- Transform3D(Basis(rootPart.worldRotation).Scaled Vector3.One, rootPart.worldPosition)
            this.Transform3dToMatricesBuffers 0 <| matrices[0][0]
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
                    part.spinAngle <- part.spinAngle + spinAngleDelta
                    // 不然运行久了浮点数精度不够，Quaternion 不再是 Normalized，乘法报错
                    if part.spinAngle > Mathf.Pi * 2f then
                        part.spinAngle <- part.spinAngle - Mathf.Pi * 2f
                    // 注意是修改 Quaternion 四元数，3D 不推荐修改 Rotation 旋转
                    // Quaternion 需要 Normalized()，不然运行久了浮点数精度不够，赋值给 Transform3D 报错
                    part.worldRotation <-
                        (parent.worldRotation
                         * (part.rotation * Quaternion.FromEuler(Vector3(0f, part.spinAngle, 0f))))
                            .Normalized()

                    part.worldPosition <- parent.worldPosition + parent.worldRotation * (1.5f * scale * part.direction)
                    levelParts[fpi] <- part

                    levelMatrices[fpi] <-
                        Transform3D(Basis(part.worldRotation).Scaled(Vector3.One * scale), part.worldPosition)

                    this.Transform3dToMatricesBuffers idx <| levelMatrices[fpi]
                    idx <- idx + 1

            RenderingServer.MultimeshSetBuffer(multiMeshIns.Multimesh.GetRid(), matricesBuffers)
