using System;
using System.Collections.Generic;
using System.Linq;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Hexasphere;

// MIT 协议参考：https://github.com/Em3rgencyLT/Hexasphere/blob/master/Assets/Code/Hexasphere/Point.cs
public class Point
{
    private readonly Vector3 _position;

    private const float PointComparisonAccuracy = 0.0001f;

    public Point(Vector3 position)
    {
        Id = Guid.NewGuid().ToString();
        _position = position;
        Faces = [];
    }

    private Point(Vector3 position, string id, List<Face> faces)
    {
        Faces = [];

        Id = id;
        _position = position;
        Faces = faces;
    }

    public Vector3 Position => _position;

    public string Id { get; }

    public List<Face> Faces { get; }

    public void AssignFace(Face face)
    {
        Faces.Add(face);
    }

    public List<Point> Subdivide(Point target, int count, Func<Point, Point> findDuplicatePointIfExists)
    {
        var segments = new List<Point> { this };

        for (var i = 1; i <= count; i++)
        {
            var x = _position.X * (1 - (float)i / count) + target.Position.X * ((float)i / count);
            var y = _position.Y * (1 - (float)i / count) + target.Position.Y * ((float)i / count);
            var z = _position.Z * (1 - (float)i / count) + target.Position.Z * ((float)i / count);

            var newPoint = findDuplicatePointIfExists(new Point(new Vector3(x, y, z)));
            segments.Add(newPoint);
        }

        segments.Add(target);
        return segments;
    }

    public Point ProjectToSphere(float radius, float t)
    {
        var projectionPoint = radius / _position.Length();
        var x = _position.X * projectionPoint * t;
        var y = _position.Y * projectionPoint * t;
        var z = _position.Z * projectionPoint * t;
        return new Point(new Vector3(x, y, z), Id, Faces);
    }

    public List<Face> GetOrderedFaces()
    {
        if (Faces.Count == 0) return Faces;
        var orderedList = new List<Face> { Faces[0] };

        var currentFace = orderedList[0];
        while (orderedList.Count < Faces.Count)
        {
            var existingIds = orderedList.Select(face => face.Id).ToList();
            var neighbour = Faces.First(face => !existingIds.Contains(face.Id) && face.IsAdjacentToFace(currentFace));
            currentFace = neighbour;
            orderedList.Add(currentFace);
        }

        return orderedList;
    }

    public static bool IsOverlapping(Point a, Point b) =>
        Mathf.Abs(a.Position.X - b.Position.X) <= PointComparisonAccuracy &&
        Mathf.Abs(a.Position.Y - b.Position.Y) <= PointComparisonAccuracy &&
        Mathf.Abs(a.Position.Z - b.Position.Z) <= PointComparisonAccuracy;

    public override string ToString() => $"{_position.X},{_position.Y},{_position.Z}";
    public string ToJson() => $"{{\"x\":{_position.X},\"y\":{_position.Y},\"z\":{_position.Z}, \"guid\":\"{Id}\"}}";
}