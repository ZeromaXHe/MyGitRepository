using System;
using System.IO;
using Godot;

namespace ProceduralPlanet.Scripts.Utils;

public static class ConvertUtils
{
    public static byte[] Vec3ArrToBytes(Vector3[] vec3Arr)
    {
        using var ms = new MemoryStream();
        using var writer = new BinaryWriter(ms);
        foreach (var vertex in vec3Arr)
        {
            writer.Write(vertex.X);
            writer.Write(vertex.Y);
            writer.Write(vertex.Z);
        }

        return ms.ToArray();
    }

    public static byte[] FloatsToBytes(float[] floats)
    {
        var bytes = new byte[floats.Length * sizeof(float)];
        for (var i = 0; i < floats.Length; i++)
            Buffer.BlockCopy(BitConverter.GetBytes(floats[i]), 0, bytes, i * sizeof(float), sizeof(float));
        return bytes;
    }

    public static byte[] DoublesToBytes(double[] doubles)
    {
        var bytes = new byte[doubles.Length * sizeof(double)];
        for (var i = 0; i < doubles.Length; i++)
            Buffer.BlockCopy(BitConverter.GetBytes(doubles[i]), 0, bytes, i * sizeof(double), sizeof(double));
        return bytes;
    }

    public static float[] BytesToFloats(byte[] bytes)
    {
        using var ms = new MemoryStream(bytes);
        using var reader = new BinaryReader(ms);
        var floatCount = bytes.Length / sizeof(float);
        var floatArray = new float[floatCount];
        for (var i = 0; i < floatCount; i++)
            floatArray[i] = reader.ReadSingle();
        return floatArray;
    }
}