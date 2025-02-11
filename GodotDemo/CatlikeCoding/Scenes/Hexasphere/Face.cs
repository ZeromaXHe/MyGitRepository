using System;
using System.Collections.Generic;
using System.Linq;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Hexasphere;

// MIT 协议参考：https://github.com/Em3rgencyLT/Hexasphere/blob/master/Assets/Code/Hexasphere/Face.cs
public class Face
{
    public Face(Point point1, Point point2, Point point3, bool trackFaceInPoints = true)
    {
        Id = Guid.NewGuid().ToString();

        var centerX = (point1.Position.X + point2.Position.X + point3.Position.X) / 3;
        var centerY = (point1.Position.Y + point2.Position.Y + point3.Position.Y) / 3;
        var centerZ = (point1.Position.Z + point2.Position.Z + point3.Position.Z) / 3;
        var center = new Vector3(centerX, centerY, centerZ);

        //Determine correct winding order
        var normal = GetNormal(point1, point2, point3);
        Points = IsNormalPointingAwayFromOrigin(center, normal)
            ? [point1, point3, point2]
            : [point1, point2, point3];

        if (trackFaceInPoints)
        {
            Points.ForEach(point => point.AssignFace(this));
        }
    }

    public string Id { get; }
    public List<Point> Points { get; }

    public List<Point> GetOtherPoints(Point point)
    {
        if (!IsPointPartOfFace(point))
        {
            throw new ArgumentException("Given point must be one of the points on the face!");
        }

        return Points.Where(facePoint => facePoint.Id != point.Id).ToList();
    }

    public bool IsAdjacentToFace(Face face)
    {
        var thisFaceIds = Points.Select(point => point.Id).ToList();
        var otherFaceIds = face.Points.Select(point => point.Id).ToList();
        return thisFaceIds.Intersect(otherFaceIds).ToList().Count == 2;
    }

    public Point GetCenter()
    {
        var centerX = (Points[0].Position.X + Points[1].Position.X + Points[2].Position.X) / 3;
        var centerY = (Points[0].Position.Y + Points[1].Position.Y + Points[2].Position.Y) / 3;
        var centerZ = (Points[0].Position.Z + Points[1].Position.Z + Points[2].Position.Z) / 3;

        return new Point(new Vector3(centerX, centerY, centerZ));
    }

    private bool IsPointPartOfFace(Point point)
    {
        return Points.Any(facePoint => facePoint.Id == point.Id);
    }

    private static Vector3 GetNormal(Point point1, Point point2, Point point3)
    {
        var side1 = point2.Position - point1.Position;
        var side2 = point3.Position - point1.Position;

        var cross = side1.Cross(side2);

        return cross / cross.Length();
    }

    private static bool IsNormalPointingAwayFromOrigin(Vector3 surface, Vector3 normal)
    {
        //Does adding the normal vector to the center point of the face get you closer or further from the center of the polyhedron?
        return Vector3.Zero.DistanceTo(surface) < Vector3.Zero.DistanceTo(surface + normal);
    }
}