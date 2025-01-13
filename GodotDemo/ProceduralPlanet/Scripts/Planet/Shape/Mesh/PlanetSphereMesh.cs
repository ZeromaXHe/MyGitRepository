using System.Collections.Generic;
using Godot;

namespace ProceduralPlanet.Scripts.Planet.Shape.Mesh;

[Tool]
[GlobalClass]
public partial class PlanetSphereMesh : Resource
{
    // TODO: 在这里添加 QuadTree
    public List<Vector3> Vertices;
    public List<int> Triangles;
    private int _resolution;

    private int _numDivisions;
    private int _numVertsPerFace;

    // 组成初始 12 边的顶点对的索引
    private static readonly int[] VertexPairs =
        [0, 1, 0, 2, 0, 3, 0, 4, 1, 2, 2, 3, 3, 4, 4, 1, 5, 1, 5, 2, 5, 3, 5, 4];

    // 组成初始 8 个 GLTFAccessor 的边三角形的索引
    private static readonly int[] EdgeTriplets =
        [0, 1, 4, 1, 2, 5, 2, 3, 6, 3, 0, 7, 8, 9, 4, 9, 10, 5, 10, 11, 6, 11, 8, 7];

    // 六个初始顶点
    private static readonly Vector3[] BaseVertices =
        [Vector3.Up, Vector3.Left, Vector3.Back, Vector3.Right, Vector3.Forward, Vector3.Down];

    public PlanetSphereMesh()
    {
    }
    
    public PlanetSphereMesh(int resolution)
    {
        _resolution = resolution;
        _numDivisions = Mathf.Max(0, resolution);
        _numVertsPerFace = ((_numDivisions + 3) * (_numDivisions + 3) - (_numDivisions + 3)) / 2;

        Vertices = [];
        Triangles = [];
        Vertices.AddRange(BaseVertices);
        // 创建 12 边，一起做的是添加 n 个顶点（n = numDivisions）
        var edges = new Edge[12];
        for (var i = 0; i < VertexPairs.Length; i += 2)
        {
            var startVertex = Vertices[VertexPairs[i]];
            var endVertex = Vertices[VertexPairs[i + 1]];

            var edgeVertexIndices = new int[_numDivisions + 2];
            edgeVertexIndices[0] = VertexPairs[i];
            // 沿着边增加顶点
            for (var divisionIndex = 0; divisionIndex < _numDivisions; divisionIndex++)
            {
                var t = (divisionIndex + 1f) / (_numDivisions + 1f);
                edgeVertexIndices[divisionIndex + 1] = Vertices.Count;
                Vertices.Add(startVertex.Slerp(endVertex, t));
            }

            edgeVertexIndices[_numDivisions + 1] = VertexPairs[i + 1];
            var edgeIndex = i / 2;
            edges[edgeIndex] = new Edge(edgeVertexIndices);
        }

        // 创建面
        for (var i = 0; i < EdgeTriplets.Length; i += 3)
        {
            var faceIndex = i / 3;
            var reverse = faceIndex >= 4;
            CreateFace(edges[EdgeTriplets[i]], edges[EdgeTriplets[i + 1]], edges[EdgeTriplets[i + 2]], reverse);
        }
    }

    private void CreateFace(Edge sideA, Edge sideB, Edge bottom, bool reverse)
    {
        var numPointsInEdge = sideA.VertexIndices.Length;
        var vertexMap = new List<int> { sideA.VertexIndices[0] };
        for (var i = 1; i < numPointsInEdge - 1; i++)
        {
            // Side A 顶点
            vertexMap.Add(sideA.VertexIndices[i]);
            // 增加 sideA 和 sideB 间的顶点
            var sideAVertex = Vertices[sideA.VertexIndices[i]];
            var sideBVertex = Vertices[sideB.VertexIndices[i]];
            var numInnerPoints = i - 1;
            for (var j = 0; j < numInnerPoints; j++)
            {
                var t = (j + 1f) / (numInnerPoints + 1f);
                vertexMap.Add(Vertices.Count);
                Vertices.Add(sideAVertex.Slerp(sideBVertex, t));
            }

            // Side B 顶点
            vertexMap.Add(sideB.VertexIndices[i]);
        }

        // 增加底边顶点
        for (var i = 0; i < numPointsInEdge; i++)
            vertexMap.Add(bottom.VertexIndices[i]);
        // 三角剖分
        var numRows = _numDivisions + 1;
        for (var row = 0; row < numRows; row++)
        {
            // 沿着左边的顶点遵循 quadratic 顺序：0, 1, 3, 6, 10, 15...
            // 第 n 个可以通过下式计算：(n ^ 2 - n) / 2
            var topVertex = ((row + 1) * (row + 1) - row - 1) / 2;
            var bottomVertex = ((row + 2) * (row + 2) - row - 2) / 2;

            var numTrianglesInRow = 1 + 2 * row;
            for (var column = 0; column < numTrianglesInRow; column++)
            {
                int v0, v1, v2;
                if (column % 2 == 0)
                {
                    v0 = topVertex;
                    v1 = bottomVertex + 1;
                    v2 = bottomVertex;
                    topVertex++;
                    bottomVertex++;
                }
                else
                {
                    v0 = topVertex;
                    v1 = bottomVertex;
                    v2 = topVertex - 1;
                }
                Triangles.Add(vertexMap[v0]);
                if (reverse)
                {
                    Triangles.Add(vertexMap[v2]);
                    Triangles.Add(vertexMap[v1]);
                }
                else
                {
                    Triangles.Add(vertexMap[v1]);
                    Triangles.Add(vertexMap[v2]);
                }
            }
        }
    }
}

internal class Edge(int[] vertexIndices)
{
    internal readonly int[] VertexIndices = vertexIndices;
}