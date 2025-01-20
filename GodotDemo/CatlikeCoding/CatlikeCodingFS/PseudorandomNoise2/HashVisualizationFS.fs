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

[<AbstractClass>]
type HashVisualizationFS() =
    inherit Node3D()

    let mutable hashes: uint array = null
    let mutable hashesBuffer: float32 array = null
    let stride = 16 // 12 Transform + 4 Color
    let mutable config = Vector4.Zero

    let mutable ready = false
    let mutable multiMeshIns: MultiMeshInstance3D = null

    abstract InstanceMesh: Mesh with get, set
    abstract Material: Material with get, set
    abstract Resolution: int with get, set
    abstract Seed: int with get, set
    abstract VerticalOffset: float32 with get, set

    member this.GetHashColor idx =
        let hash = hashes[idx]

        (1f / 255f)
        * Vector3(float32 (hash &&& 255u), float32 ((hash >>> 8) &&& 255u), float32 ((hash >>> 16) &&& 255u))

    member this.Execute i (hash: SmallXXHash) =
        let mutable v = int <| Mathf.Floor(config.Y * float32 i + 0.00001f)
        let u = i - int config.X * v - this.Resolution / 2
        v <- v - this.Resolution / 2
        // 注意如果不是链式代码，则必须是 mutable；否则 Eat 虽然不报错但无效
        let hash = hash.Eat(u).Eat(v)
        hashes[i] <- hash.ToUint()

    member this.HashJob i =
        let mutable v = Mathf.Floor(config.Y * float32 i + 0.00001f)
        let u = float32 i - config.X * v

        hashesBuffer[i * stride] <- config.Y
        // hashesBuffer[i * stride + 1] <- 0f
        // hashesBuffer[i * stride + 2] <- 0f
        hashesBuffer[i * stride + 3] <- config.Y * (u + 0.5f) - 0.5f // X
        // hashesBuffer[i * stride + 4] <- 0f
        hashesBuffer[i * stride + 5] <- config.Y
        // hashesBuffer[i * stride + 6] <- 0f
        hashesBuffer[i * stride + 7] <- config.Z * 1f / 255f * (float32 (hashes[i] >>> 24) - 0.5f)
        // hashesBuffer[i * stride + 8] <- 0f
        // hashesBuffer[i * stride + 9] <- 0f
        hashesBuffer[i * stride + 10] <- config.Y
        hashesBuffer[i * stride + 11] <- -config.Y * (v + 0.5f) + 0.5f // Godot Z 和 Unity 不同，前后相反
        let color = this.GetHashColor i
        hashesBuffer[i * stride + 12] <- color.X
        hashesBuffer[i * stride + 13] <- color.Y
        hashesBuffer[i * stride + 14] <- color.Z
        hashesBuffer[i * stride + 15] <- 1f


    override this._Ready() =
        let length = this.Resolution * this.Resolution
        hashes <- Array.zeroCreate length
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

        config <-
            Vector4(
                float32 this.Resolution,
                1f / float32 this.Resolution,
                this.VerticalOffset / float32 this.Resolution,
                0f
            )

        let hash = SmallXXHash.Seed(this.Seed)

        for i in 0 .. length - 1 do
            this.Execute i hash
            this.HashJob i

        RenderingServer.MultimeshSetBuffer(multiMeshIns.Multimesh.GetRid(), hashesBuffer)
        ready <- true
