namespace CatlikeCodingFS.PseudorandomNoise2

open Godot

type SmallXXHash =
    struct
        val accumulator: uint

        new(accumulator: uint) = { accumulator = accumulator }

        static member PrimeA = 0b10011110001101110111100110110001u
        static member PrimeB = 0b10000101111010111100101001110111u
        static member PrimeC = 0b11000010101100101010111000111101u
        static member PrimeD = 0b00100111110101001110101100101111u
        static member PrimeE = 0b00010110010101100110011110110001u

        static member private RotateLeft (data: uint) steps =
            (data <<< steps) ||| (data >>> (32 - steps))

        static member Seed(seed: int) =
            SmallXXHash(uint seed + SmallXXHash.PrimeE)

        member this.Eat(data: int) =
            SmallXXHash(
                SmallXXHash.PrimeD
                * SmallXXHash.RotateLeft (this.accumulator + uint data * SmallXXHash.PrimeC) 17
            )

        member this.Eat(data: byte) =
            SmallXXHash(
                SmallXXHash.PrimeA
                * SmallXXHash.RotateLeft (this.accumulator + uint data * SmallXXHash.PrimeE) 11
            )

        member this.ToUint() =
            let mutable avalanche = this.accumulator
            avalanche <- avalanche ^^^ (avalanche >>> 15)
            avalanche <- avalanche * SmallXXHash.PrimeB
            avalanche <- avalanche ^^^ (avalanche >>> 13)
            avalanche <- avalanche * SmallXXHash.PrimeC
            avalanche <- avalanche ^^^ (avalanche >>> 16)
            avalanche
    end

type SmallXXHash4 =
    struct
        val accumulator: Vector4I

        new(accumulator: Vector4I) = { accumulator = accumulator }
        new(hash: SmallXXHash) = { accumulator = int hash.accumulator * Vector4I.One }

        static member PrimeB = 0b10000101111010111100101001110111
        static member PrimeC = 0b11000010101100101010111000111101
        static member PrimeD = 0b00100111110101001110101100101111
        static member PrimeE = 0b00010110010101100110011110110001

        static member private RotateLeft (data: Vector4I) steps =
            Vector4I(
                (data.X <<< steps) ||| (data.X >>> (32 - steps)),
                (data.Y <<< steps) ||| (data.Y >>> (32 - steps)),
                (data.Z <<< steps) ||| (data.Z >>> (32 - steps)),
                (data.W <<< steps) ||| (data.W >>> (32 - steps))
            )

        static member Seed(seed: Vector4I) =
            SmallXXHash4(seed + Vector4I.One * SmallXXHash4.PrimeE)

        member this.Eat(data: Vector4I) =
            SmallXXHash4(
                SmallXXHash4.PrimeD
                * SmallXXHash4.RotateLeft (this.accumulator + data * SmallXXHash4.PrimeC) 17
            )

        member this.ToUint() =
            let mutable avalanche = this.accumulator

            let xorRightShift shift =
                avalanche <-
                    Vector4I(
                        avalanche.X ^^^ (avalanche.X >>> shift),
                        avalanche.Y ^^^ (avalanche.Y >>> shift),
                        avalanche.Z ^^^ (avalanche.Z >>> shift),
                        avalanche.W ^^^ (avalanche.W >>> shift)
                    )

            xorRightShift 15
            avalanche <- avalanche * SmallXXHash4.PrimeB
            xorRightShift 13
            avalanche <- avalanche * SmallXXHash4.PrimeC
            xorRightShift 16
            avalanche
    end

type ShapesJob =
    struct
        val positions: Vector3 array
        val normals: Vector3 array
        val resolution: float32
        val invResolution: float32
        val trs: Transform3D

        new(positions, normals, res, trs) =
            { positions = positions
              normals = normals
              resolution = res
              invResolution = 1f / res
              trs = trs }

        member this.Execute i =
            let mutable uv = Vector2.Zero
            uv.Y <- Mathf.Floor(this.invResolution * float32 i + 0.00001f)
            uv.X <- this.invResolution * (float32 i - this.resolution * uv.Y + 0.5f) - 0.5f
            uv.Y <- this.invResolution * (uv.Y + 0.5f) - 0.5f
            this.positions[i] <- this.trs * Vector3(uv.X, 0f, uv.Y)
            this.normals[i] <- (this.trs * Vector3.Up).Normalized()
    end

type HashJob =
    struct
        val positions: Vector3 array
        val hashes: uint array
        val hash: SmallXXHash
        val domain: Transform3D

        new(positions, hashes, hash, domain) =
            { positions = positions
              hashes = hashes
              hash = hash
              domain = domain }

        member this.Execute i =
            let p = this.domain * this.positions[i]
            let u = int <| Mathf.Floor(p.X)
            let v = int <| Mathf.Floor(p.Y)
            let w = int <| Mathf.Floor(p.Z)
            // 注意如果不是链式代码，则必须是 mutable；否则 Eat 虽然不报错但无效
            let hash = this.hash.Eat(u).Eat(v).Eat(w)
            this.hashes[i] <- hash.ToUint()
    end

type DirtyEnum =
    | Normal = 0
    | Resolution = 1
    | Displacement = 2

[<AbstractClass>]
type HashVisualizationFS() =
    inherit Node3D()

    let mutable hashes: uint array = null
    let mutable hashesBuffer: float32 array = null
    let mutable positions: Vector3 array = null
    let mutable normals: Vector3 array = null
    let stride = 16 // 12 Transform + 4 Color
    let mutable config = Vector4.Zero

    let mutable ready = false
    let mutable isDirty = false
    let mutable multiMeshIns: MultiMeshInstance3D = null

    abstract InstanceMesh: Mesh with get, set
    abstract Material: Material with get, set
    abstract Resolution: int with get, set
    abstract Seed: int with get, set
    abstract Displacement: float32 with get, set
    abstract Domain: Transform3D with get, set

    member this.GetHashColor idx =
        let hash = hashes[idx]

        (1f / 255f)
        * Vector3(float32 (hash &&& 255u), float32 ((hash >>> 8) &&& 255u), float32 ((hash >>> 16) &&& 255u))

    // 参考源码 /Assets/Materials/HashGPU.hlsl
    member this.HashGPU i =
        let offset = config.Z * 1f / 255f * (float32 (hashes[i] >>> 24) - 0.5f)
        hashesBuffer[i * stride] <- config.Y
        // hashesBuffer[i * stride + 1] <- 0f
        // hashesBuffer[i * stride + 2] <- 0f
        hashesBuffer[i * stride + 3] <- positions[i].X + offset * normals[i].X
        // hashesBuffer[i * stride + 4] <- 0f
        hashesBuffer[i * stride + 5] <- config.Y
        // hashesBuffer[i * stride + 6] <- 0f
        hashesBuffer[i * stride + 7] <- positions[i].Y + offset * normals[i].Y
        // hashesBuffer[i * stride + 8] <- 0f
        // hashesBuffer[i * stride + 9] <- 0f
        hashesBuffer[i * stride + 10] <- config.Y
        hashesBuffer[i * stride + 11] <- positions[i].Z + offset * normals[i].Z
        let color = this.GetHashColor i
        hashesBuffer[i * stride + 12] <- color.X
        hashesBuffer[i * stride + 13] <- color.Y
        hashesBuffer[i * stride + 14] <- color.Z
        hashesBuffer[i * stride + 15] <- 1f

    member this.SetConfig() =
        config <- Vector4(float32 this.Resolution, 1f / float32 this.Resolution, this.Displacement, 0f)

    member this.SetDirty dirtyEnum =
        if ready then
            isDirty <- true
            // 对于 C# 调用的方法，不能用 function 关键字
            match dirtyEnum with
            | DirtyEnum.Resolution ->
                let length = this.Resolution * this.Resolution
                hashes <- Array.zeroCreate length
                positions <- Array.zeroCreate length
                hashesBuffer <- Array.zeroCreate <| length * stride
                multiMeshIns.Multimesh.InstanceCount <- length
                this.SetConfig()
            | DirtyEnum.Displacement -> this.SetConfig()
            | _ -> ()

    override this._Ready() =
        let length = this.Resolution * this.Resolution
        hashes <- Array.zeroCreate length
        positions <- Array.zeroCreate length
        normals <- Array.zeroCreate length
        hashesBuffer <- Array.zeroCreate <| length * stride
        // 必须在代码里初始化 MultiMeshInstance3D 节点，不然场景里面既有的节点会被持久化
        // 否则 .tscn 将会包含了那些变化的 Transform 数组，一方面会很大，而且另一方面每次运行后都会被更新。其实完全没必要保存
        multiMeshIns <- new MultiMeshInstance3D()
        multiMeshIns.Multimesh <- new MultiMesh()
        multiMeshIns.Multimesh.SetTransformFormat(MultiMesh.TransformFormatEnum.Transform3D)
        multiMeshIns.Multimesh.Mesh <- this.InstanceMesh
        (multiMeshIns.Multimesh.Mesh :?> PrimitiveMesh).Material <- this.Material
        multiMeshIns.Multimesh.UseColors <- true
        multiMeshIns.Multimesh.InstanceCount <- length
        this.AddChild multiMeshIns

        this.SetConfig()
        // // 监听默认变换，好像只能用这个的方式
        // let monitor =
        //     fun name ->
        //         if name = "position" || name = "rotation" || name = "scale" then
        //             isDirty <- true
        //
        // if Engine.IsEditorHint() then
        //     EditorInterface.Singleton.GetInspector().add_PropertyEdited monitor
        //
        // // 程序集卸载前的清理逻辑（好像还是没有用……）
        // // let handle = GCHandle.Alloc(this)
        // let alc = AssemblyLoadContext.GetLoadContext(Assembly.GetExecutingAssembly())
        // GD.Print $"FS ALC: {alc} ALC is null? {alc = null}"
        //
        // alc.add_Unloading (fun assemblyLoadContext ->
        //     GD.Print "Start Unloading"
        //     // Attempt to disconnect a nonexistent connection from '@EditorInspector@5391:<EditorInspector#514775343968>'. Signal: 'property_edited', callable: 'Delegate::Invoke'.
        //     EditorInterface.Singleton.GetInspector().remove_PropertyEdited monitor
        //     GD.Print "End Unloading"
        // // handle.Free()
        // )

        isDirty <- true
        ready <- true

    override this._Process(delta) =
        if ready && isDirty then
            isDirty <- false

            let shapesJob =
                ShapesJob(positions, normals, float32 this.Resolution, this.GlobalTransform)

            let hashJob = HashJob(positions, hashes, SmallXXHash.Seed(this.Seed), this.Domain)

            for i in 0 .. hashes.Length - 1 do
                shapesJob.Execute i
                hashJob.Execute i
                this.HashGPU i

            RenderingServer.MultimeshSetBuffer(multiMeshIns.Multimesh.GetRid(), hashesBuffer)
