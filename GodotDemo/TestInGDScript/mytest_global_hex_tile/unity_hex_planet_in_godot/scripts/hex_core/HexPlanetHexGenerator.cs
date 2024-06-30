using System.Collections.Generic;
using System.Linq;
using Godot;

namespace UnityHexPlanet
{
    public static class HexPlanetHexGenerator
    {
        public static void GeneratePlanetTilesAndChunks(HexPlanet planet)
        {
            List<Vector3> points = GeodesicPoints.GenPoints(planet.subdivisions, planet.radius);
            List<HexTile> tiles = GenHexTiles(planet, ref points);

            List<Vector3> chunkOrigins = GeodesicPoints.GenPoints(planet.chunkSubdivisions, planet.radius);
            List<HexChunk> chunks = GenHexChunks(planet, tiles, chunkOrigins);
            planet.chunks = chunks;
            planet.tiles = tiles;
        }

        private static List<HexChunk> GenHexChunks(HexPlanet planet, List<HexTile> tiles, List<Vector3> chunkCenters)
        {
            int chunkCount = chunkCenters.Count;
            List<HexChunk> chunks = new List<HexChunk>();
            for (int i = 0; i < chunkCount; i++)
            {
                chunks.Add(new HexChunk(i, planet, chunkCenters[i]));
            }

            for (int i = 0; i < tiles.Count; i++)
            {
                HexChunk bestChunk = (from chunk in chunks
                    orderby (tiles[i].Center - chunk.Origin).LengthSquared()
                    select chunk).Take(1).ToList()[0];
                bestChunk.AddTile(tiles[i].Id);
                tiles[i].SetChunk(bestChunk.Id);
            }

            return chunks;
        }

        private static List<HexTile> GenHexTiles(HexPlanet planet, ref List<Vector3> sphereVerts)
        {
            List<HexTile> hexTiles = new List<HexTile>();

            // Get unique points
            // 获取去重过的顶点
            List<Vector3> uniqueVerts = sphereVerts.Distinct().ToList();

            // Construct an oct tree out of all points that will be centers of hexes
            // 使用所有将成为六边形的中心的点，构建八叉树
            OctTree<Vector3> vertOctTree = new OctTree<Vector3>(Vector3.One * (planet.radius * -1.1f),
                Vector3.One * (planet.radius * 1.1f));
            foreach (Vector3 v in uniqueVerts)
            {
                vertOctTree.InsertPoint(v, v);
            }

            // Get the maximum distance between two neighbors
            // 两个相邻地块的最大距离
            float maxDistBetweenNeighbots = Mathf.Sqrt((from vert in uniqueVerts
                orderby (vert - uniqueVerts[uniqueVerts.Count - 1]).LengthSquared()
                select (vert - uniqueVerts[uniqueVerts.Count - 1]).LengthSquared()).Take(7).ToList()[6]) * 1.2f;

            // Generate the tiles
            // 构建瓦片
            for (int i = 0; i < uniqueVerts.Count; i++)
            {
                Vector3 uniqueVert = uniqueVerts[i];
                List<Vector3> closestVerts = vertOctTree.GetPoints(uniqueVert, Vector3.One * maxDistBetweenNeighbots);
                var closest = (from vert in closestVerts
                    orderby (vert - uniqueVert).LengthSquared()
                    select vert).Take(7).ToList();
                // 第七个点比第六个点远了 1.5 倍的话，截取六个点（五边形）
                if (closest.Count < 7 || (closest[6] - uniqueVert).Length() > (closest[5] - uniqueVert).Length() * 1.5)
                {
                    closest = closest.Take(6).ToList();
                }

                // 排除掉自己
                closest = closest.Skip(1).ToList();

                // Order the closest so an increase in index revolves them counter clockwise
                // 按随索引增加，逆时针排序的顺序排列最近的点
                // BUG: This is a hack and might result in bugs
                Vector3 angleAxis = Vector3.Up + (Vector3.One * 0.1f);
                closest = (from vert in closest
                    orderby -(vert - uniqueVert).SignedAngleTo(angleAxis, uniqueVert)
                    select vert).ToList();

                List<Vector3> hexVerts = new List<Vector3>();
                for (int j = 0; j < closest.Count; j++)
                {
                    hexVerts.Add(uniqueVert.Lerp(closest[j], 0.66666666f)
                        .Lerp(uniqueVert.Lerp(closest[(j + 1) % closest.Count], 0.66666666f), 0.5f));
                }

                // Find center vertex
                // 找到中间顶点
                Vector3 center = Vector3.Zero;
                for (int j = 0; j < hexVerts.Count; j++)
                {
                    center += hexVerts[j];
                }

                center /= hexVerts.Count;

                HexTile hexTile = planet.terrainGenerator.CreateHexTile(i, planet, center, hexVerts);
                hexTiles.Add(hexTile);
            }

            // Construct an oct tree out of all points that will be centers of hexes
            OctTree<HexTile> hexOctTree = new OctTree<HexTile>(Vector3.One * (planet.radius * -1.1f),
                Vector3.One * (planet.radius * 1.1f));
            foreach (HexTile h in hexTiles)
            {
                hexOctTree.InsertPoint(h, h.Center);
            }

            // Find neighbors
            for (int i = 0; i < hexTiles.Count; i++)
            {
                HexTile currentTile = hexTiles[i];
                List<HexTile> closestHexes =
                    hexOctTree.GetPoints(currentTile.Center, Vector3.One * maxDistBetweenNeighbots);
                var closest = (from tile in closestHexes
                    orderby (tile.Center - currentTile.Center).LengthSquared()
                    select tile).Take(7).ToList();
                if ((closest[6].Center - currentTile.Center).Length() >
                    (closest[5].Center - currentTile.Center).Length() * 1.5)
                {
                    closest = closest.Take(6).ToList(); // Must be a pentagon
                }

                // Exclude self, closest tile
                closest = closest.Skip(1).ToList();

                // Order the tiles based on the vertices
                List<Vector3> verts = currentTile.Vertices;
                List<HexTile> orderedNeighbors = new List<HexTile>();

                for (int j = 0; j < verts.Count; j++)
                {
                    HexTile a = (from tile in closest
                        orderby -((verts[j] + verts[(j + 1) % verts.Count]) / 2).Normalized()
                            .Dot(tile.Center.Normalized())
                        select tile).ToList()[0];
                    orderedNeighbors.Add(a);
                }


                currentTile.AddNeighbors(orderedNeighbors);
            }

            // Run each tile through the generator
            foreach (HexTile tile in hexTiles)
            {
                planet.terrainGenerator.AfterTileCreation(tile);
            }

            return hexTiles;
        }
    }
}