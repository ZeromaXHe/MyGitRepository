namespace CatlikeCodingFS.GodotOfficialDemo._3D.NavigationMeshChunks

open Godot
open Godot.Collections

type NavMeshChunkDemoFS() =
    inherit Node3D()

    let mapCellSize = 0.25f
    let chunkSize = 16
    let cellSize = 0.25f
    let agentRadius = 0.5f
    let chunkIdToRegion = new Dictionary()

    let mutable pathStartPosition = Vector3.Zero

    member this.CalculateSourceGeometryBounds(pSourceGeometry: NavigationMeshSourceGeometryData3D) =
        if pSourceGeometry.HasMethod "get_bounds" then
            // Godot 4.3 Patch 添加了 get_bounds() 函数，可以做同样的事，但更快
            (pSourceGeometry.Call "get_bounds").AsAabb()
        else
            let mutable bounds = Aabb()
            let mutable firstVertex = true
            let vertices = pSourceGeometry.GetVertices()
            let verticesCount = vertices.Length / 3

            for i in 0 .. verticesCount - 1 do
                let vertex = Vector3(vertices[i * 3], vertices[i * 3 + 1], vertices[i * 3 + 2])

                if firstVertex then
                    firstVertex <- false
                    bounds.Position <- vertex
                else
                    bounds <- bounds.Expand vertex

            for projectedObstruction in pSourceGeometry.GetProjectedObstructions() do
                let dict = projectedObstruction.AsGodotDictionary()
                let projectedObstructionVertices = dict["vertices"].AsFloat32Array()

                for i in 0 .. projectedObstructionVertices.Length / 3 - 1 do
                    let vertex =
                        Vector3(
                            projectedObstructionVertices[i * 3],
                            projectedObstructionVertices[i * 3 + 1],
                            projectedObstructionVertices[i * 3 + 2]
                        )

                    if firstVertex then
                        firstVertex <- false
                        bounds.Position <- vertex
                    else
                        bounds <- bounds.Expand vertex

            bounds

    member this.CreateRegionChunks
        (chunksRootNode: Node)
        (pSourceGeometry: NavigationMeshSourceGeometryData3D)
        (pChunkSize: float32)
        pAgentRadius
        =
        // 我们需要知道输入几何体需要多少个块。
        // 所以首先得到一个覆盖所有顶点的轴对齐边界框。
        let inputGeometryBounds = this.CalculateSourceGeometryBounds pSourceGeometry
        // 将边界框光栅化为块网格，以了解所需块的范围。
        let startChunk = (inputGeometryBounds.Position / pChunkSize).Floor()

        let endChunk =
            ((inputGeometryBounds.Position + inputGeometryBounds.Size) / pChunkSize).Floor()
        // NavigationMesh.border_size 仅限于 xz 轴。
        // 所以我们只能为 y 轴烘焙块，而且需要跨越整个y轴上的烘焙边界。
        // 如果我们不这样做，我们会创建重复的多边形并将它们堆叠在一起，导致合并错误。
        let boundsMinHeight = startChunk.Y
        let boundsMaxHeight = endChunk.Y + pChunkSize
        let chunkY = 0

        for chunkZ in startChunk.Z .. endChunk.Z do
            for chunkX in startChunk.X .. endChunk.X do
                let chunkId = Vector3I(int chunkX, chunkY, int chunkZ)

                let chunkBoundingBox =
                    Aabb(
                        Vector3(chunkX, boundsMinHeight, chunkZ) * pChunkSize,
                        Vector3(pChunkSize, boundsMaxHeight, pChunkSize)
                    )
                // 我们扩展块边界框以包含来自所有相邻块的几何图形以便边缘可以对齐。
                // 边界大小与我们的增长量相同，因此最终的导航网格最终达到了预期的块大小。
                let bakingBounds = chunkBoundingBox.Grow pChunkSize
                let chunkNavmesh = new NavigationMesh()
                chunkNavmesh.GeometryParsedGeometryType <- NavigationMesh.ParsedGeometryType.StaticColliders
                chunkNavmesh.CellSize <- cellSize
                chunkNavmesh.CellHeight <- cellSize
                chunkNavmesh.FilterBakingAabb <- bakingBounds
                chunkNavmesh.BorderSize <- pChunkSize
                chunkNavmesh.AgentRadius <- pAgentRadius
                NavigationServer3D.BakeFromSourceGeometryData(chunkNavmesh, pSourceGeometry)
                // 我们在这里重置烘焙边界的唯一原因是不渲染其调试。
                chunkNavmesh.FilterBakingAabb <- Aabb()
                // 捕捉顶点位置，以避免浮点精度的大多数光栅化问题。
                let navmeshVertices = chunkNavmesh.Vertices

                for i in 0 .. navmeshVertices.Length - 1 do
                    let vertex = navmeshVertices[i]
                    navmeshVertices[i] <- vertex.Snapped(mapCellSize * 0.1f)

                chunkNavmesh.Vertices <- navmeshVertices
                let chunkRegion = new NavigationRegion3D()
                chunkRegion.NavigationMesh <- chunkNavmesh
                chunksRootNode.AddChild chunkRegion
                chunkIdToRegion[chunkId] <- Variant.CreateFrom chunkRegion

    override this._Ready() =
        NavigationServer3D.SetDebugEnabled true
        pathStartPosition <- this.GetNode<Node3D>("%DebugPaths").GlobalPosition
        let map = this.GetWorld3D().NavigationMap
        NavigationServer3D.MapSetCellSize(map, mapCellSize)
        // 禁用性能昂贵的边缘连接间距功能。
        // 合并导航网格边缘不需要此功能。
        // 如果边缘对齐良好，它们将按边缘 key 合并。
        NavigationServer3D.MapSetUseEdgeConnections(map, false)
        // 解析 parse root （解析根） 节点下方的碰撞形状。
        let sourceGeometry = new NavigationMeshSourceGeometryData3D()
        let parseSetting = new NavigationMesh()
        parseSetting.GeometryParsedGeometryType <- NavigationMesh.ParsedGeometryType.StaticColliders
        NavigationServer3D.ParseSourceGeometryData(parseSetting, sourceGeometry, this.GetNode<Node3D> "%ParseRootNode")

        this.CreateRegionChunks
            (this.GetNode<Node3D> "%ChunksContainer")
            sourceGeometry
            (float32 chunkSize * cellSize)
            agentRadius

    override this._Process _ =
        let mouseCursorPosition = this.GetViewport().GetMousePosition()
        let map = this.GetWorld3D().NavigationMap
        // 当映射从未同步且为空时，不要查询。
        if NavigationServer3D.MapGetIterationId map <> 0u then
            let camera = this.GetViewport().GetCamera3D()
            let cameraRayLength = 1000f
            let cameraRayStart = camera.ProjectRayOrigin mouseCursorPosition

            let cameraRayEnd =
                cameraRayStart + camera.ProjectRayNormal mouseCursorPosition * cameraRayLength

            let closestPointOnNavmesh =
                NavigationServer3D.MapGetClosestPointToSegment(map, cameraRayStart, cameraRayEnd)

            if Input.IsMouseButtonPressed MouseButton.Left then
                pathStartPosition <- closestPointOnNavmesh

            (this.GetNode<Node3D> "%DebugPaths").GlobalPosition <- pathStartPosition

            let pathDebugCorridorFunnel =
                this.GetNode<NavigationAgent3D> "%PathDebugCorridorFunnel"

            let pathDebugEdgeCentered = this.GetNode<NavigationAgent3D> "%PathDebugEdgeCentered"
            pathDebugCorridorFunnel.TargetPosition <- closestPointOnNavmesh
            pathDebugEdgeCentered.TargetPosition <- closestPointOnNavmesh
            pathDebugCorridorFunnel.GetNextPathPosition() |> ignore
            pathDebugEdgeCentered.GetNextPathPosition() |> ignore
