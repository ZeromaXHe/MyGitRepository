namespace CatlikeCodingFS.GodotOfficialDemo._3D.VoxelGame

open System
open Godot
open Godot.Collections

[<AbstractClass>]
type VoxelWorldFS() =
    inherit Node()

    let CHUNK_MIDPOINT = Vector3(0.5f, 0.5f, 0.5f) * float32 ChunkFS.ChunkSize
    let CHUNK_END_SIZE = ChunkFS.ChunkSize - 1
    let mutable renderDistance = 0
    let mutable deleteDistance = 0
    let mutable effectiveRenderDistance = 0
    let mutable oldPlayerChunk = Vector3I.Zero
    let mutable generating = true
    let mutable deleting = false
    let mutable chunks = new Dictionary()
    
    abstract ChunkCsInitiator: Func<ChunkFS>

    member this.RenderDistance
        with get () = renderDistance
        and set value =
            renderDistance <- value
            deleteDistance <- value + 2

    member this.EffectiveRenderDistance = effectiveRenderDistance
    member this.Player = this.GetNode<CharacterBody3D> "../Player"

    interface IVoxelWorld with
        override this.GetBlockGlobalPosition blockGlobalPosition =
            this.GetBlockGlobalPosition blockGlobalPosition

    member this.GetBlockGlobalPosition(blockGlobalPosition: Vector3I) =
        let chunkPosition = blockGlobalPosition / ChunkFS.ChunkSize

        if chunks.ContainsKey chunkPosition then
            let chunk = chunks[chunkPosition].As<ChunkFS>()

            let vec3 =
                Vector3(float32 blockGlobalPosition.X, float32 blockGlobalPosition.Y, float32 blockGlobalPosition.Z)

            let vec3posMod = vec3.PosMod(float32 ChunkFS.ChunkSize)
            let subPosition = Vector3I(int vec3posMod.X, int vec3posMod.Y, int vec3posMod.Z)

            if chunk.Data.ContainsKey subPosition then
                chunk.Data[subPosition].AsInt32()
            else
                0
        else
            0

    member this.SetBlockGlobalPosition (blockGlobalPosition: Vector3I) blockId =
        let vec =
            (Vector3(float32 blockGlobalPosition.X, float32 blockGlobalPosition.Y, float32 blockGlobalPosition.Z)
             / float32 ChunkFS.ChunkSize)
                .Floor()

        let chunkPosition = Vector3I(int vec.X, int vec.Y, int vec.Z)
        let chunk = chunks[chunkPosition].As<ChunkFS>()

        let vec3 =
            Vector3(float32 blockGlobalPosition.X, float32 blockGlobalPosition.Y, float32 blockGlobalPosition.Z)
                .PosMod(float32 ChunkFS.ChunkSize)

        let subPosition = Vector3I(int vec3.X, int vec3.Y, int vec3.Z)

        if blockId = 0 then
            chunk.Data.Remove subPosition |> ignore
        else
            chunk.Data[subPosition] <- blockId

        chunk.Regenerate()
        // 我们也可能需要重新生成一些相邻块
        if ChunkFS.IsBlockTransparent blockId then
            if subPosition.X = 0 then
                chunks[Variant.CreateFrom(chunkPosition + Vector3I.Left)]
                    .As<ChunkFS>()
                    .Regenerate()
            elif subPosition.X = CHUNK_END_SIZE then
                chunks[Variant.CreateFrom(chunkPosition + Vector3I.Right)]
                    .As<ChunkFS>()
                    .Regenerate()

            if subPosition.Z = 0 then
                chunks[Variant.CreateFrom(chunkPosition + Vector3I.Forward)]
                    .As<ChunkFS>()
                    .Regenerate()
            elif subPosition.Z = CHUNK_END_SIZE then
                chunks[Variant.CreateFrom(chunkPosition + Vector3I.Back)]
                    .As<ChunkFS>()
                    .Regenerate()

            if subPosition.Y = 0 then
                chunks[Variant.CreateFrom(chunkPosition + Vector3I.Down)]
                    .As<ChunkFS>()
                    .Regenerate()
            elif subPosition.Y = CHUNK_END_SIZE then
                chunks[Variant.CreateFrom(chunkPosition + Vector3I.Up)]
                    .As<ChunkFS>()
                    .Regenerate()

    member this.CleanUp() =
        for chunkPositionKeyV in chunks.Keys do
            let chunkPositionKey = chunkPositionKeyV.As<Vector3I>()
            let thread = chunks[chunkPositionKey].As<ChunkFS>().Thread

            if thread <> null then
                thread.WaitToFinish() |> ignore

        chunks <- new Dictionary()
        this.SetProcess false

        for c in this.GetChildren() do
            c.Free()

    member this.DeleteFarAwayChunks(playerChunk: Vector3I) =
        oldPlayerChunk <- playerChunk
        // 如果我们需要删除块，给新块系统一个机会来跟上
        effectiveRenderDistance <- Mathf.Max(1, effectiveRenderDistance - 1)
        let mutable deletedThisFrame = 0
        // 我们如果移动得快时，需要更激进地删除旧块
        // 计算这个的简单方式是通过使用有效渲染距离
        // 这个公式中的指定值是任意的，并来自实践试验
        let maxDeletions = Mathf.Clamp(2 * (renderDistance - effectiveRenderDistance), 2, 8)
        // 也把握机会删除远处的块
        let mutable directReturn = false

        for chunkPositionKeyV in chunks.Keys do
            if not directReturn then
                let chunkPositionKey = chunkPositionKeyV.As<Vector3I>()

                if
                    Vector3(float32 playerChunk.X, float32 playerChunk.Y, float32 playerChunk.Z)
                        .DistanceTo(
                            Vector3(float32 chunkPositionKey.X, float32 chunkPositionKey.Y, float32 chunkPositionKey.Z)
                        ) > float32 deleteDistance
                then
                    let chunk = chunks[chunkPositionKey].As<ChunkFS>()
                    let thread = chunk.Thread

                    if thread <> null then
                        thread.WaitToFinish() |> ignore

                    chunk.QueueFree()
                    chunks.Remove chunkPositionKey |> ignore
                    deletedThisFrame <- deletedThisFrame + 1
                    // 限制每帧删除总数，来避免延迟高峰（lag spikes）
                    if deletedThisFrame >= maxDeletions then
                        // 下一帧继续删除
                        deleting <- true
                        directReturn <- true

        if not directReturn then
            deleting <- false

    override this._Process _ =
        this.RenderDistance <- SettingsFS.Instance.RenderDistance
        let vec = (this.Player.GlobalTransform.Origin / float32 ChunkFS.ChunkSize).Round()
        let mutable playerChunk = Vector3I(int vec.X, int vec.Y, int vec.Z)

        if deleting || playerChunk <> oldPlayerChunk then
            this.DeleteFarAwayChunks playerChunk
            generating <- true

        if generating then
            // GD.Print "世界生成块"
            // 尝试在玩家前进方向提前生成块
            playerChunk.Y <-
                playerChunk.Y
                + Mathf.RoundToInt(
                    Mathf.Clamp(this.Player.Velocity.Y, -float32 renderDistance / 4f, float32 renderDistance / 4f)
                )

            let mutable directReturn = false
            // 检查在范围内存在的块。如果它不存在，创建它
            for x in playerChunk.X - effectiveRenderDistance .. playerChunk.X + effectiveRenderDistance - 1 do
                if not directReturn then
                    for y in playerChunk.Y - effectiveRenderDistance .. playerChunk.Y + effectiveRenderDistance - 1 do
                        if not directReturn then
                            for z in
                                playerChunk.Z - effectiveRenderDistance .. playerChunk.Z + effectiveRenderDistance - 1 do
                                let chunkPosition = Vector3I(x, y, z)

                                if
                                    not directReturn
                                    && Vector3(float32 playerChunk.X, float32 playerChunk.Y, float32 playerChunk.Z)
                                        .DistanceTo(
                                            Vector3(
                                                float32 chunkPosition.X,
                                                float32 chunkPosition.Y,
                                                float32 chunkPosition.Z
                                            )
                                        )
                                       <= float32 renderDistance
                                    && not <| chunks.ContainsKey chunkPosition
                                then
                                    // GD.Print "创建新块"
                                    let chunk = this.ChunkCsInitiator.Invoke()
                                    chunk.ChunkPosition <- chunkPosition
                                    chunks[chunkPosition] <- Variant.CreateFrom chunk
                                    this.AddChild chunk
                                    directReturn <- true

            if not directReturn then
                // 如果我们没有生成任何块（即没有 return），下一步做什么？
                if effectiveRenderDistance < renderDistance then
                    // 我们可以通过增大有效距离来继续下一阶段
                    effectiveRenderDistance <- effectiveRenderDistance + 1
                else
                    // 有效渲染距离被最大化了，完成生成
                    generating <- false
