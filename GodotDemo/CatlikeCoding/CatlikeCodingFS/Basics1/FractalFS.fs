namespace CatlikeCodingFS.Basics1

open Godot

type FractalPart =
    struct
        val mutable direction: Vector3
        val mutable rotation: Quaternion
        val mutable meshIns: MeshInstance3D

        new(direction, rotation, transform) =
            { direction = direction
              rotation = rotation
              meshIns = transform }
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

    let mutable ready = false

    abstract Depth: int with get, set
    abstract MeshF: Mesh with get, set
    abstract MaterialF: Material with get, set

    member this.CreatePart levelIndex childIndex (scale: float32) =
        // 用 CSGSphere3D 的话，旋转起来直接卡爆
        let meshIns = new MeshInstance3D()
        meshIns.Name <- $"FractalPartL{levelIndex}C{childIndex}"
        meshIns.ScaleObjectLocal <| scale * Vector3.One
        this.AddChild meshIns
        meshIns.Mesh <- this.MeshF
        (meshIns.Mesh :?> SphereMesh).Material <- this.MaterialF
        FractalPart(directions[childIndex], rotations[childIndex], meshIns)

    override this._Ready() =
        parts <- Array.zeroCreate this.Depth
        let mutable length = 1

        for i in 0 .. parts.Length - 1 do
            parts[i] <- Array.zeroCreate length
            length <- length * 5

        let mutable scale = 1f
        parts[0][0] <- this.CreatePart 0 0 scale

        for li in 1 .. parts.Length - 1 do
            scale <- scale * 0.5f
            let levelParts = parts[li]

            for fpi in 0..5 .. levelParts.Length - 1 do // 两个 .. 的情况，中间值是 skip 值
                for ci in 0..4 do
                    levelParts[fpi + ci] <- this.CreatePart li ci scale

        ready <- true

    override this._Process(delta) =
        if ready then
            let deltaRotation =
                Quaternion.FromEuler(Vector3(0f, Mathf.DegToRad 22.5f * float32 delta, 0f))

            let mutable rootPart = parts[0][0]
            rootPart.rotation <- rootPart.rotation * deltaRotation
            // 注意是修改 Quaternion 四元数，3D 不推荐修改 Rotation 旋转
            rootPart.meshIns.Quaternion <- rootPart.rotation
            parts[0][0] <- rootPart

            for li in 1 .. parts.Length - 1 do
                let parentParts = parts[li - 1]
                let levelParts = parts[li]

                for fpi in 0 .. levelParts.Length - 1 do
                    let parentMeshIns = parentParts[fpi / 5].meshIns
                    let mutable part = levelParts[fpi]
                    part.rotation <- part.rotation * deltaRotation
                    // Unity 的 Transform.localRotation 是 Quaternion
                    // 注意是修改 Quaternion 四元数，3D 不推荐修改 Rotation 旋转
                    part.meshIns.Quaternion <- parentMeshIns.Quaternion * part.rotation

                    part.meshIns.Position <-
                        parentMeshIns.Position
                        + parentMeshIns.Quaternion * (1.5f * part.meshIns.Scale.X * part.direction)

                    levelParts[fpi] <- part
