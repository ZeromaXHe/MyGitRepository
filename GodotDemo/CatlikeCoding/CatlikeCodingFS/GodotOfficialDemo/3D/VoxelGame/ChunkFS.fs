namespace CatlikeCodingFS.GodotOfficialDemo._3D.VoxelGame

open Godot
open Godot.Collections

type IVoxelWorld =
    abstract GetBlockGlobalPosition: Vector3I -> int

type ChunkFS() =
    inherit StaticBody3D()
    // 这些块被 VoxelWorld 实例化，并赋予数据
    // 在此之后，块在 _Ready() 函数中完成设置它们自己
    // 如果块被修改，它的“Regenerate”方法被调用
    static member ChunkSize = 16 // 与 TerrainGenerator 保持同步
    static member TextureSheetWidth = 8
    static member ChunkLastIndex = ChunkFS.ChunkSize - 1
    static member TextureTileSize = 1f / float32 ChunkFS.TextureSheetWidth

    member val Data = new Dictionary() with get, set
    member val ChunkPosition = Vector3I.Zero with get, set
    member val Thread: GodotThread = null with get, set

    member this.VoxelWorld = this.GetParent<IVoxelWorld>()

    member this.CreateBlockCollider(blockSubPosition: Vector3) =
        // GD.Print $"生成方块碰撞体中…… {blockSubPosition}"
        let collider = new CollisionShape3D()
        collider.Shape <- new BoxShape3D()
        let mutable trans = collider.Transform

        trans.Origin <-
            Vector3(float32 blockSubPosition.X, float32 blockSubPosition.Y, float32 blockSubPosition.Z)
            + Vector3.One / 2f

        collider.Transform <- trans
        this.AddChild collider

    member this.GenerateChunkCollider() =
        // GD.Print $"生成块碰撞体中…… {this.Data.Count}"
        if this.Data.Count = 0 then
            // 避免 StaticBody3D 没有碰撞体的错误
            this.CreateBlockCollider Vector3.Zero
            this.CollisionLayer <- 0u
            this.CollisionMask <- 0u
        else
            // 对于每一块，生成碰撞体。确保碰撞层级都被启用
            this.CollisionLayer <- 0xFFFFFu
            this.CollisionMask <- 0xFFFFFu

            for blockPositionV in this.Data.Keys do
                let blockPosition = blockPositionV.As<Vector3I>()
                let blockId = this.Data[blockPosition].AsInt32()

                if blockId <> 27 && blockId <> 28 then
                    this.CreateBlockCollider blockPosition

    static member CalculateBlockVerts(blockPosition: Vector3) =
        [| Vector3(blockPosition.X, blockPosition.Y, blockPosition.Z)
           Vector3(blockPosition.X, blockPosition.Y, blockPosition.Z + 1f)
           Vector3(blockPosition.X, blockPosition.Y + 1f, blockPosition.Z)
           Vector3(blockPosition.X, blockPosition.Y + 1f, blockPosition.Z + 1f)
           Vector3(blockPosition.X + 1f, blockPosition.Y, blockPosition.Z)
           Vector3(blockPosition.X + 1f, blockPosition.Y, blockPosition.Z + 1f)
           Vector3(blockPosition.X + 1f, blockPosition.Y + 1f, blockPosition.Z)
           Vector3(blockPosition.X + 1f, blockPosition.Y + 1f, blockPosition.Z + 1f) |]

    static member CalculateBlockUvs blockId =
        // 这个方法仅支持方形纹理表
        let row = blockId / ChunkFS.TextureSheetWidth
        let col = blockId % ChunkFS.TextureSheetWidth

        [|
           // Godot 4 有个奇怪 bug，纹理边缘的接缝。添加边距 0.01 来“修复”它
           ChunkFS.TextureTileSize * Vector2(float32 col + 0.01f, float32 row + 0.01f)
           ChunkFS.TextureTileSize * Vector2(float32 col + 0.01f, float32 row + 0.99f)
           ChunkFS.TextureTileSize * Vector2(float32 col + 0.99f, float32 row + 0.01f)
           ChunkFS.TextureTileSize * Vector2(float32 col + 0.99f, float32 row + 0.99f) |]

    static member IsBlockTransparent blockId =
        blockId = 0 || (blockId > 25 && blockId < 30)

    member this.DrawBlockFace (surfaceTool: SurfaceTool) (verts: Vector3 array) (uvs: Vector2 array) =
        surfaceTool.SetUV uvs[1]
        surfaceTool.AddVertex verts[1]
        surfaceTool.SetUV uvs[2]
        surfaceTool.AddVertex verts[2]
        surfaceTool.SetUV uvs[3]
        surfaceTool.AddVertex verts[3]

        surfaceTool.SetUV uvs[2]
        surfaceTool.AddVertex verts[2]
        surfaceTool.SetUV uvs[1]
        surfaceTool.AddVertex verts[1]
        surfaceTool.SetUV uvs[0]
        surfaceTool.AddVertex verts[0]

    member this.DrawBlockMesh (surfaceTool: SurfaceTool) (blockSubPosition: Vector3I) blockId =
        let verts = ChunkFS.CalculateBlockVerts blockSubPosition
        let uvs = ChunkFS.CalculateBlockUvs blockId
        let mutable topUvs = uvs
        let mutable bottomUvs = uvs
        // 灌木块按它们特别的方式绘制
        if blockId = 27 || blockId = 28 then
            this.DrawBlockFace surfaceTool [| verts[2]; verts[0]; verts[7]; verts[5] |] uvs
            this.DrawBlockFace surfaceTool [| verts[7]; verts[5]; verts[2]; verts[0] |] uvs
            this.DrawBlockFace surfaceTool [| verts[3]; verts[1]; verts[6]; verts[4] |] uvs
            this.DrawBlockFace surfaceTool [| verts[6]; verts[4]; verts[3]; verts[1] |] uvs
        else
            // 允许一些块有不同的上下纹理
            if blockId = 3 then // 草
                topUvs <- ChunkFS.CalculateBlockUvs 0
                bottomUvs <- ChunkFS.CalculateBlockUvs 2
            elif blockId = 5 then // 壁炉
                topUvs <- ChunkFS.CalculateBlockUvs 31
                bottomUvs <- topUvs
            elif blockId = 12 then // 原木
                topUvs <- ChunkFS.CalculateBlockUvs 30
                bottomUvs <- topUvs
            elif blockId = 19 then // 书柜
                topUvs <- ChunkFS.CalculateBlockUvs 4
                bottomUvs <- topUvs
            // 对法线块的主渲染代码
            let mutable otherBlockPosition = blockSubPosition + Vector3I.Left
            let mutable otherBlockId = 0

            if otherBlockPosition.X = -1 then
                otherBlockId <-
                    this.VoxelWorld.GetBlockGlobalPosition(otherBlockPosition + this.ChunkPosition * ChunkFS.ChunkSize)
            elif this.Data.ContainsKey otherBlockPosition then
                otherBlockId <- this.Data[otherBlockPosition].AsInt32()

            if blockId <> otherBlockId && ChunkFS.IsBlockTransparent otherBlockId then
                this.DrawBlockFace surfaceTool [| verts[2]; verts[0]; verts[3]; verts[1] |] uvs

            otherBlockPosition <- blockSubPosition + Vector3I.Right
            otherBlockId <- 0

            if otherBlockPosition.X = ChunkFS.ChunkSize then
                otherBlockId <-
                    this.VoxelWorld.GetBlockGlobalPosition(otherBlockPosition + this.ChunkPosition * ChunkFS.ChunkSize)
            elif this.Data.ContainsKey otherBlockPosition then
                otherBlockId <- this.Data[otherBlockPosition].AsInt32()

            if blockId <> otherBlockId && ChunkFS.IsBlockTransparent otherBlockId then
                this.DrawBlockFace surfaceTool [| verts[7]; verts[5]; verts[6]; verts[4] |] uvs

            otherBlockPosition <- blockSubPosition + Vector3I.Forward
            otherBlockId <- 0

            if otherBlockPosition.Z = -1 then
                otherBlockId <-
                    this.VoxelWorld.GetBlockGlobalPosition(otherBlockPosition + this.ChunkPosition * ChunkFS.ChunkSize)
            elif this.Data.ContainsKey otherBlockPosition then
                otherBlockId <- this.Data[otherBlockPosition].AsInt32()

            if blockId <> otherBlockId && ChunkFS.IsBlockTransparent otherBlockId then
                this.DrawBlockFace surfaceTool [| verts[6]; verts[4]; verts[2]; verts[0] |] uvs

            otherBlockPosition <- blockSubPosition + Vector3I.Back
            otherBlockId <- 0

            if otherBlockPosition.Z = ChunkFS.ChunkSize then
                otherBlockId <-
                    this.VoxelWorld.GetBlockGlobalPosition(otherBlockPosition + this.ChunkPosition * ChunkFS.ChunkSize)
            elif this.Data.ContainsKey otherBlockPosition then
                otherBlockId <- this.Data[otherBlockPosition].AsInt32()

            if blockId <> otherBlockId && ChunkFS.IsBlockTransparent otherBlockId then
                this.DrawBlockFace surfaceTool [| verts[3]; verts[1]; verts[7]; verts[5] |] uvs

            otherBlockPosition <- blockSubPosition + Vector3I.Down
            otherBlockId <- 0

            if otherBlockPosition.Y = -1 then
                otherBlockId <-
                    this.VoxelWorld.GetBlockGlobalPosition(otherBlockPosition + this.ChunkPosition * ChunkFS.ChunkSize)
            elif this.Data.ContainsKey otherBlockPosition then
                otherBlockId <- this.Data[otherBlockPosition].AsInt32()

            if blockId <> otherBlockId && ChunkFS.IsBlockTransparent otherBlockId then
                this.DrawBlockFace surfaceTool [| verts[4]; verts[5]; verts[0]; verts[1] |] bottomUvs

            otherBlockPosition <- blockSubPosition + Vector3I.Up
            otherBlockId <- 0

            if otherBlockPosition.Y = ChunkFS.ChunkSize then
                otherBlockId <-
                    this.VoxelWorld.GetBlockGlobalPosition(otherBlockPosition + this.ChunkPosition * ChunkFS.ChunkSize)
            elif this.Data.ContainsKey otherBlockPosition then
                otherBlockId <- this.Data[otherBlockPosition].AsInt32()

            if blockId <> otherBlockId && ChunkFS.IsBlockTransparent otherBlockId then
                this.DrawBlockFace surfaceTool [| verts[2]; verts[3]; verts[6]; verts[7] |] topUvs

    member this.GenerateChunkMesh() =
        // GD.Print $"正在生成网格…… {this.Data.Count}"
        if this.Data.Count > 0 then
            let surfaceTool = new SurfaceTool()
            surfaceTool.Begin Mesh.PrimitiveType.Triangles
            // 对于每个块，向 SurfaceTool 添加数据并生成碰撞体
            for blockPositionV in this.Data.Keys do
                let blockPosition = blockPositionV.As<Vector3I>()
                let blockId = this.Data[blockPosition].AsInt32()
                this.DrawBlockMesh surfaceTool blockPosition blockId
            // 从 SurfaceTool 数据中创建块的网格
            surfaceTool.GenerateNormals()
            surfaceTool.GenerateTangents()
            surfaceTool.Index()
            let arrayMesh = surfaceTool.Commit()
            let mi = new MeshInstance3D()
            mi.Mesh <- arrayMesh

            mi.MaterialOverride <-
                GD.Load<StandardMaterial3D> "res://Materials/GodotOfficialDemo/3D/VoxelGame/BlockMaterial.tres"

            Callable.From(fun () -> this.AddChild mi).CallDeferred()

    member this.Regenerate() =
        // 先清除所有旧节点
        for c in this.GetChildren() do
            this.RemoveChild c
            c.QueueFree()
        // 然后生成新的
        this.GenerateChunkCollider()
        this.GenerateChunkMesh()

    override this._Ready() =
        let mutable trans = this.Transform
        let vec3i = this.ChunkPosition * ChunkFS.ChunkSize
        trans.Origin <- Vector3(float32 vec3i.X, float32 vec3i.Y, float32 vec3i.Z)
        this.Transform <- trans
        this.Name <- $"{this.ChunkPosition}"

        if SettingsFS.Instance.WorldType = 0 then
            this.Data <- TerrainGenerator.randomBlocks ChunkFS.ChunkSize
        else
            this.Data <- TerrainGenerator.flat ChunkFS.ChunkSize this.ChunkPosition
        // 因为物理限制，我们只能在主线程添加碰撞体
        this.GenerateChunkCollider()
        // 然而，我们能使用线程做网格生成
        // GD.Print "线程异步生成网格……"
        this.Thread <- new GodotThread()
        this.Thread.Start <| Callable.From this.GenerateChunkMesh |> ignore
