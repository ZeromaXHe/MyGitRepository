using System.Collections.Generic;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Hexasphere;

// MIT 协议参考：https://github.com/Em3rgencyLT/Hexasphere/blob/master/Assets/Code/Hexasphere/MeshDetails.cs
public class MeshDetails(List<Vector3> vertices, List<int> triangles)
{
    public List<Vector3> Vertices => vertices;
    public List<int> Triangles => triangles;
}