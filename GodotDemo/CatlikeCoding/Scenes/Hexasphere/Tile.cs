using System.Collections.Generic;
using System.Linq;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Hexasphere;

// MIT 协议参考：https://github.com/Em3rgencyLT/Hexasphere/blob/master/Assets/Code/Hexasphere/Tile.cs
public class Tile
{
    private readonly Point _center;
    private readonly float _radius;
    private readonly float _size;

    private readonly List<Point> _neighbourCenters;

    public Tile(Point center, float radius, float size)
    {
        Points = [];
        Faces = [];
        _neighbourCenters = [];
        Neighbours = [];

        _center = center;
        _radius = radius;
        _size = Mathf.Max(0.01f, Mathf.Min(1f, size));

        var icosahedronFaces = center.GetOrderedFaces();
        StoreNeighbourCenters(icosahedronFaces);
        BuildFaces(icosahedronFaces);
    }

    public List<Point> Points { get; }
    public List<Face> Faces { get; }
    public List<Tile> Neighbours { get; private set; }

    public void ResolveNeighbourTiles(List<Tile> allTiles)
    {
        var neighbourIds = _neighbourCenters.Select(center => center.Id).ToList();
        Neighbours = allTiles.Where(tile => neighbourIds.Contains(tile._center.Id)).ToList();
    }

    public override string ToString() => $"{_center.Position.X},{_center.Position.Y},{_center.Position.Z}";

    public string ToJson() =>
        $"{{\"centerPoint\":{_center.ToJson()},\"boundary\":[{string.Join(",", Points.Select(point => point.ToJson()))}]}}";

    private void StoreNeighbourCenters(List<Face> icosahedronFaces)
    {
        icosahedronFaces.ForEach(face =>
        {
            var otherPoints = face.GetOtherPoints(_center);
            otherPoints.ForEach(point =>
            {
                if (_neighbourCenters.FirstOrDefault(centerPoint => centerPoint.Id == point.Id) == null)
                {
                    _neighbourCenters.Add(point);
                }
            });
        });
    }

    private void BuildFaces(List<Face> icosahedronFaces)
    {
        var polygonPoints = icosahedronFaces.Select(face => _center.Position.Lerp(face.GetCenter().Position, _size))
            .ToList();
        polygonPoints.ForEach(pos => Points.Add(new Point(pos).ProjectToSphere(_radius, 0.5f)));
        Faces.Add(new Face(Points[0], Points[1], Points[2]));
        Faces.Add(new Face(Points[0], Points[2], Points[3]));
        Faces.Add(new Face(Points[0], Points[3], Points[4]));
        if (Points.Count > 5)
        {
            Faces.Add(new Face(Points[0], Points[4], Points[5]));
        }
    }
}