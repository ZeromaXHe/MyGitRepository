using System.Collections.Generic;
using System.Linq;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Hexasphere;

// MIT 协议参考：https://github.com/Em3rgencyLT/Hexasphere/blob/master/Assets/Code/Hexasphere/Hexasphere.cs
public class Hexasphere
{
    private readonly float _radius;
    private readonly int _divisions;
    private readonly float _hexSize;

    private readonly List<Point> _points;
    private readonly List<Point> _framePoints;
    private readonly List<Face> _icosahedronFaces;

    public Hexasphere(float radius, int divisions, float hexSize)
    {
        var time = Time.GetTicksMsec();
        GD.Print($"new Hexasphere with divisions {divisions}, start at: {time}");
        _radius = radius;
        _divisions = divisions;
        _hexSize = hexSize;

        Tiles = [];
        _points = [];
        _framePoints = [];

        _icosahedronFaces = ConstructIcosahedron();
        var time2 = Time.GetTicksMsec();
        GD.Print($"ConstructIcosahedron cost: {time2 - time} ms");

        SubdivideIcosahedron();
        time = Time.GetTicksMsec();
        GD.Print($"SubdivideIcosahedron cost: {time - time2} ms");

        ConstructTiles();
        time2 = Time.GetTicksMsec();
        GD.Print($"ConstructTiles cost: {time2 - time} ms");

        MeshDetails = StoreMeshDetails();
        time = Time.GetTicksMsec();
        GD.Print($"StoreMeshDetails cost: {time - time2} ms");
    }

    public List<Tile> Tiles { get; }
    public MeshDetails MeshDetails { get; }

    public string ToJson() =>
        $"{{\"radius\":{_radius},\"tiles\":[{string.Join(",", Tiles.Select(tile => tile.ToJson()))}]}}";

    public string ToObj()
    {
        var objString = $"#Hexasphere. Radius {_radius}, divisions {_divisions}, hexagons scaled to {_hexSize}\n";
        objString += string.Join("\n", MeshDetails.Vertices.Select(vertex => $"v {vertex.X} {vertex.Y} {vertex.Z}"));
        //+1 to all values as .obj indexes start from 1 -.-
        var offsetTriangles = MeshDetails.Triangles.Select(index => index + 1).ToList();
        for (var i = 0; i < offsetTriangles.Count; i += 3)
        {
            objString +=
                $"f {offsetTriangles[i]} {offsetTriangles[i + 1]} {offsetTriangles[i + 2]}\n";
        }

        return objString;
    }

    private List<Face> ConstructIcosahedron()
    {
        const float tao = Mathf.Pi / 2;
        const float defaultSize = 100f;

        List<Point> icosahedronCorners =
        [
            new Point(new Vector3(defaultSize, tao * defaultSize, 0f)),
            new Point(new Vector3(-defaultSize, tao * defaultSize, 0f)),
            new Point(new Vector3(defaultSize, -tao * defaultSize, 0f)),
            new Point(new Vector3(-defaultSize, -tao * defaultSize, 0f)),
            new Point(new Vector3(0, defaultSize, tao * defaultSize)),
            new Point(new Vector3(0, -defaultSize, tao * defaultSize)),
            new Point(new Vector3(0, defaultSize, -tao * defaultSize)),
            new Point(new Vector3(0, -defaultSize, -tao * defaultSize)),
            new Point(new Vector3(tao * defaultSize, 0f, defaultSize)),
            new Point(new Vector3(-tao * defaultSize, 0f, defaultSize)),
            new Point(new Vector3(tao * defaultSize, 0f, -defaultSize)),
            new Point(new Vector3(-tao * defaultSize, 0f, -defaultSize))
        ];
        icosahedronCorners.ForEach(point => CachePoint(true, point));

        return
        [
            new Face(icosahedronCorners[0], icosahedronCorners[1], icosahedronCorners[4], false),
            new Face(icosahedronCorners[1], icosahedronCorners[9], icosahedronCorners[4], false),
            new Face(icosahedronCorners[4], icosahedronCorners[9], icosahedronCorners[5], false),
            new Face(icosahedronCorners[5], icosahedronCorners[9], icosahedronCorners[3], false),
            new Face(icosahedronCorners[2], icosahedronCorners[3], icosahedronCorners[7], false),
            new Face(icosahedronCorners[3], icosahedronCorners[2], icosahedronCorners[5], false),
            new Face(icosahedronCorners[7], icosahedronCorners[10], icosahedronCorners[2], false),
            new Face(icosahedronCorners[0], icosahedronCorners[8], icosahedronCorners[10], false),
            new Face(icosahedronCorners[0], icosahedronCorners[4], icosahedronCorners[8], false),
            new Face(icosahedronCorners[8], icosahedronCorners[2], icosahedronCorners[10], false),
            new Face(icosahedronCorners[8], icosahedronCorners[4], icosahedronCorners[5], false),
            new Face(icosahedronCorners[8], icosahedronCorners[5], icosahedronCorners[2], false),
            new Face(icosahedronCorners[1], icosahedronCorners[0], icosahedronCorners[6], false),
            new Face(icosahedronCorners[3], icosahedronCorners[9], icosahedronCorners[11], false),
            new Face(icosahedronCorners[6], icosahedronCorners[10], icosahedronCorners[7], false),
            new Face(icosahedronCorners[3], icosahedronCorners[11], icosahedronCorners[7], false),
            new Face(icosahedronCorners[11], icosahedronCorners[6], icosahedronCorners[7], false),
            new Face(icosahedronCorners[6], icosahedronCorners[0], icosahedronCorners[10], false),
            new Face(icosahedronCorners[11], icosahedronCorners[1], icosahedronCorners[6], false),
            new Face(icosahedronCorners[9], icosahedronCorners[1], icosahedronCorners[11], false)
        ];
    }

    private Point CachePoint(bool checkFrameExist, Point point)
    {
        if (checkFrameExist)
        {
            var existingPoint =
                _framePoints.FirstOrDefault(candidatePoint => Point.IsOverlapping(candidatePoint, point));
            if (existingPoint != null)
                return existingPoint;
            _framePoints.Add(point);
        }

        _points.Add(point);
        return point;
    }

    private void SubdivideIcosahedron()
    {
        _icosahedronFaces.ForEach(icoFace =>
        {
            var facePoints = icoFace.Points;
            var bottomSide = new List<Point> { facePoints[0] };
            var leftSide = facePoints[0].Subdivide(facePoints[1], _divisions, p => CachePoint(true, p));
            var rightSide = facePoints[0].Subdivide(facePoints[2], _divisions, p => CachePoint(true, p));
            for (var i = 1; i <= _divisions; i++)
            {
                var previousPoints = bottomSide;
                var checkFrameExist = i == _divisions;
                bottomSide = leftSide[i].Subdivide(rightSide[i], i, p => CachePoint(checkFrameExist, p));
                for (var j = 0; j < i; j++)
                {
                    //Don't need to store faces, their points will have references to them.
                    var face1 = new Face(previousPoints[j], bottomSide[j], bottomSide[j + 1]);
                    if (j == 0) continue;
                    var face2 = new Face(previousPoints[j - 1], previousPoints[j], bottomSide[j]);
                }
            }
        });
    }

    private void ConstructTiles()
    {
        _points.ForEach(point => { Tiles.Add(new Tile(point, _radius, _hexSize)); });
        Tiles.ForEach(tile => tile.ResolveNeighbourTiles());
    }

    private MeshDetails StoreMeshDetails()
    {
        List<Point> vertices = [];
        List<int> triangles = [];
        Dictionary<string, int> vertexIdToIndex = new();
        var pi = 0;
        foreach (var tile in Tiles)
        {
            foreach (var point in tile.Points)
            {
                vertices.Add(point);
                vertexIdToIndex[point.Id] = pi++;
            }
            tile.Faces.ForEach(face =>
                face.Points.ForEach(point =>
                    triangles.Add(vertexIdToIndex[point.Id])));
        }
        // Tiles.ForEach(tile =>
        // {
        //     tile.Points.ForEach(point => { vertices.Add(point); });
        //     tile.Faces.ForEach(face =>
        //     {
        //         face.Points.ForEach(point =>
        //         {
        //             var vertexIndex = vertices.FindIndex(vertex => vertex.Id == point.Id);
        //             triangles.Add(vertexIndex);
        //         });
        //     });
        // });

        return new MeshDetails(vertices.Select(point => point.Position).ToList(), triangles);
    }
}