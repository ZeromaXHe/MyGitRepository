using Godot;
using System;

[Tool]
public partial class GenMesh : MeshInstance3D
{
    [Export] private bool _update = false;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        GenerateMesh();
    }

    private void GenerateMesh()
    {
        // GDScript 的 PackedVector3Array 对应 C# Vector3[]
        var vertices = new Vector3[]
        {
            new(0, 1, 0),
            new(1, 1, 0),
            new(1, 1, 1),
            new(0, 1, 1),

            new(0, 0, 0),
            new(1, 0, 0),
            new(1, 0, 1),
            new(0, 0, 1),
        };

        // GDScript 的 PackedInt32Array 对应 C# int[]
        var indices = new[]
        {
            0, 1, 2,
            0, 2, 3,
            3, 2, 7,
            2, 6, 7,
            2, 1, 6,
            1, 5, 6,
            1, 4, 5,
            1, 0, 4,
            0, 3, 7,
            4, 0, 7,
            6, 5, 4,
            4, 7, 6,
        };

        var uvs = new Vector2[]
        {
            new(0, 0),
            new(1, 0),
            new(1, 1),
            new(0, 1),

            new(0, 0),
            new(1, 0),
            new(1, 1),
            new(0, 1),
        };

        // 更复杂的原生写法
        // var array = new Godot.Collections.Array();
        // array.Resize((int)Mesh.ArrayType.Max);
        // array[(int)Mesh.ArrayType.Vertex] = vertices;
        // array[(int)Mesh.ArrayType.Index] = indices;
        // array[(int)Mesh.ArrayType.TexUV] = uvs;
        // var arrayMesh = new ArrayMesh(); 
        // arrayMesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, array);
        // Mesh = arrayMesh;

        // 使用 SurfaceTool 工具类
        var surfaceTool = new SurfaceTool();
        surfaceTool.Begin(Mesh.PrimitiveType.Triangles);
        for (var i = 0; i < vertices.Length; i++)
        {
            surfaceTool.SetUV(uvs[i]);
            surfaceTool.AddVertex(vertices[i]);
        }

        foreach (var index in indices)
        {
            surfaceTool.AddIndex(index);
        }

        surfaceTool.GenerateNormals();
        var arrayMesh = surfaceTool.Commit();
        Mesh = arrayMesh;
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }
}