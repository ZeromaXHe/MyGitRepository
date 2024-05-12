using Godot;
using System;

[Tool]
public partial class GenTerrain : MeshInstance3D
{
    [Export(PropertyHint.Range, "20, 400, 1")]
    private int _terrainSize = 100;

    [Export(PropertyHint.Range, "1, 100, 1")]
    private int _resolution = 30;

    private const float CenterOffset = 0.5f;

    // [Export] private int _xSize = 20;
    // [Export] private int _zSize = 20;

    [Export] private int _terrainMaxHeight = 5;
    [Export] private float _noiseOffset = 0.5f;
    [Export] private bool _createCollision = false;
    [Export] private bool _removeCollision = false;

    private float _minHeight = 0;
    private float _maxHeight = 1;

    private int _lastRes = 0;
    private int _lastSize = 0;
    private int _lastHeight = 0;
    private float _lastOffset = 0;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        GenerateTerrain();
    }

    private void GenerateTerrain()
    {
        var surfaceTool = new SurfaceTool();
        surfaceTool.Begin(Mesh.PrimitiveType.Triangles);

        var n = new FastNoiseLite();
        n.NoiseType = FastNoiseLite.NoiseTypeEnum.Perlin;
        n.Frequency = 0.1f;

        for (int z = 0; z < _resolution + 1; z++)
        {
            for (int x = 0; x < _resolution + 1; x++)
            {
                // float y = n.GetNoise2D(x * _noiseOffset, z * _noiseOffset) * _terrainHeight;
                // if (y < _minHeight)
                // {
                //     _minHeight = y;
                // }
                //
                // if (y > _maxHeight)
                // {
                //     _maxHeight = y;
                // }
                //
                // surfaceTool.AddVertex(new Vector3(x, y, z));
                //
                // var uv = new Vector2(
                //     Mathf.InverseLerp(0, _xSize, x),
                //     Mathf.InverseLerp(0, _zSize, z));
                var percent = new Vector2(x, z) / _resolution;
                var pointOnMesh = new Vector3(percent.X - CenterOffset, 0, percent.Y - CenterOffset);
                var vertex = pointOnMesh * _terrainSize;
                vertex.Y = n.GetNoise2D(vertex.X * _noiseOffset, vertex.Z * _noiseOffset) * _terrainMaxHeight;

                var uv = new Vector2(percent.X, percent.Y);
                surfaceTool.SetUV(uv);
                surfaceTool.AddVertex(vertex);
                // DrawSphere(new Vector3(x, y, z));
            }
        }

        var vert = 0;
        for (int z = 0; z < _resolution; z++)
        {
            for (int x = 0; x < _resolution; x++)
            {
                surfaceTool.AddIndex(vert);
                surfaceTool.AddIndex(vert + 1);
                surfaceTool.AddIndex(vert + _resolution + 1);
                surfaceTool.AddIndex(vert + _resolution + 1);
                surfaceTool.AddIndex(vert + 1);
                surfaceTool.AddIndex(vert + _resolution + 2);
                vert++;
            }

            vert++;
        }

        surfaceTool.GenerateNormals();
        var arrayMesh = surfaceTool.Commit();
        Mesh = arrayMesh;

        // UpdateShader();
    }

    private void UpdateShader()
    {
        var mat = GetActiveMaterial(0) as ShaderMaterial;
        mat.SetShaderParameter("min_height", _minHeight);
        mat.SetShaderParameter("max_height", _maxHeight);
    }

    private void DrawSphere(Vector3 pos)
    {
        var ins = new MeshInstance3D();
        AddChild(ins);
        ins.Position = pos;
        var sphere = new SphereMesh();
        sphere.Radius = 0.1f;
        sphere.Height = 0.2f;
        ins.Mesh = sphere;
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        if (_resolution != _lastRes || _terrainSize != _lastSize ||
            _terrainMaxHeight != _lastHeight || _noiseOffset != _lastOffset)
        {
            GenerateTerrain();
            _lastRes = _resolution;
            _lastSize = _terrainSize;
            _lastHeight = _terrainMaxHeight;
            _lastOffset = _noiseOffset;
        }

        if (_removeCollision)
        {
            ClearCollision();
            _removeCollision = false;
        }
        
        if (_createCollision)
        {
            CreateTrimeshCollision();
            _createCollision = false;
        }
    }

    private void GenerateCollision()
    {
        ClearCollision();
        CreateTrimeshCollision();
    }

    private void ClearCollision()
    {
        if (GetChildCount() <= 0)
        {
            return;
        }
        foreach (var child in GetChildren())
        {
            child.Free();
        }
    }
}