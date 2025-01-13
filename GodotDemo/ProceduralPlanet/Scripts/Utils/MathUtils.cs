using System;
using Godot;

namespace ProceduralPlanet.Scripts.Utils;

public static class MathUtils
{
    public static Basis FromToRotation(Vector3 from, Vector3 to)
    {
        var axis = from.Cross(to).Normalized();
        var angle = from.AngleTo(to);
        if (axis.Length() == 0)
        {
            axis = new Vector3(1, 0, 0);
            angle = 0;
        }

        return new Basis(axis, angle);
    }

    public static float DeltaAngle(float angleA, float angleB)
    {
        var antiClockwiseDistance = Mathf.Abs(180 - angleA) + Mathf.Abs(-180 - angleB);
        var clockwiseDistance = Mathf.Abs(angleA) + Mathf.Abs(angleB);
        return Mathf.Min(clockwiseDistance, antiClockwiseDistance);
    }

    public static float MoveTowardsAngle(float angleA, float angleB, float speed)
    {
        var antiClockwiseDistance = Mathf.Abs(180 - angleA) + Mathf.Abs(-180 - angleB);
        var clockwiseDistance = Mathf.Abs(angleA) + Mathf.Abs(angleB);
        if (clockwiseDistance < antiClockwiseDistance)
        {
            angleA += speed;
            if (angleA > 360)
                angleA -= 360;
        }
        else
        {
            angleA -= speed;
            if (angleA < 0)
                angleA += 360;
        }

        return angleA;
    }

    public static Vector3 DirectionToPlanet(Vector3 direction, Vector3 origin, Vector3 pivot)
    {
        // direction.X 被视为横向移动
        // direction.Y 被视为纵向移动
        // direction.Z 未使用（可能高度？）
        var normal = origin - pivot;
        var b = Mathf.Sqrt(direction.LengthSquared() + normal.LengthSquared());
        var angle = Mathf.Asin(direction.LengthSquared() * Mathf.Sin(Mathf.Pi / 2f) / b);

        var projectedOrigin = new Plane(Vector3.Up, 0f).Project(origin);
        var perpendicularAxis = Vector3.Up.Cross(projectedOrigin.Normalized());

        // 星球 up 方向始终是 Y
        var newNormal = normal.Rotated(Vector3.Up, direction.X * angle);
        newNormal = newNormal.Rotated(perpendicularAxis, direction.Y * angle);
        return newNormal.Normalized();
    }

    public static Vector3[] RecalculateNormals(Vector3[] vertices, int[] triangles)
    {
        var normals = new Vector3[vertices.Length];
        // 重新计算法线
        for (var a = 0; a < triangles.Length; a += 3)
        {
            var b = a + 1;
            var c = a + 2;
            var ab = vertices[triangles[b]] - vertices[triangles[a]];
            var bc = vertices[triangles[c]] - vertices[triangles[b]];
            var ca = vertices[triangles[a]] - vertices[triangles[c]];
            var crossAbBc = ab.Cross(bc) * -1;
            var crossBcCa = bc.Cross(ca) * -1;
            var crossCaAb = ca.Cross(ab) * -1;
            normals[triangles[a]] += crossAbBc + crossBcCa + crossCaAb;
            normals[triangles[b]] += crossAbBc + crossBcCa + crossCaAb;
            normals[triangles[c]] += crossAbBc + crossBcCa + crossCaAb;
        }

        // 确保法线在 0， 1 之间
        for (var i = 0; i < normals.Length; i++)
            normals[i] = normals[i].Normalized();
        return normals;
    }

    // 两值的 Smooth 最大值，通过光滑参数 k 控制
    // 当 k = 0 时，这和 max(a, b) 表现一样。
    public static float SmoothMax(float a, float b, float k)
    {
        k = Mathf.Min(0f, -k);
        var h = Mathf.Max(0f, Mathf.Min(1f, (b - a + k) / (2f * k)));
        // return Mathf.Lerp(a, b, h) - k * h * (1f - h);
        return a * h + b * (1f - h) - k * h * (1f - h);
    }

    public static float Blend(float startHeight, float blendDst, float height) =>
        Mathf.SmoothStep(startHeight - blendDst / 2f, startHeight + blendDst / 2f, height);

    public static float RandSigned(RandomNumberGenerator rng) => rng.Randf() < 0f ? -1f : 1f;

    public static Vector3 RandOnUnitSphere(RandomNumberGenerator rng)
    {
        var x = rng.RandfRange(-1f, 1f);
        var y = rng.RandfRange(-1f, 1f);
        var z = rng.RandfRange(-1f, 1f);
        var dir = new Vector3(x, y, z).Normalized();
        if (dir.Length() == 0f)
            dir = Vector3.Left;
        return dir;
    }
}