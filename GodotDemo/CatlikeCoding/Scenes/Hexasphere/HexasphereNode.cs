using Godot;

namespace CatlikeCodingCSharp.Scenes.Hexasphere;

[Tool]
public partial class HexasphereNode : Node3D
{
    [Export(PropertyHint.Range, "5, 1000")]
    private float _radius = 10f;

    [Export(PropertyHint.Range, "1, 15")] private int _divisions = 4;

    [Export(PropertyHint.Range, "0.1f, 1f")]
    private float _hexSize = 1f;

    private SurfaceTool _surfaceTool;
    private MeshInstance3D _meshIns;
    private Hexasphere _hexasphere;

    private float _oldRadius;
    private int _oldDivisions;
    private float _oldHexSize;
    private float _lastUpdated;

    public override void _Ready()
    {
        _meshIns = new MeshInstance3D();
        AddChild(_meshIns);
        _surfaceTool = new SurfaceTool();
        DrawHexasphereMesh();
    }

    public override void _Process(double delta)
    {
        _lastUpdated += (float)delta;
        if (_lastUpdated < 1f) return;
        if (Mathf.Abs(_oldRadius - _radius) > 0.001f || _oldDivisions != _divisions ||
            Mathf.Abs(_oldHexSize - _hexSize) > 0.001f)
        {
            DrawHexasphereMesh();
        }
    }

    private void DrawHexasphereMesh()
    {
        _oldRadius = _radius;
        _oldDivisions = _divisions;
        _oldHexSize = _hexSize;
        _lastUpdated = 0f;

        _hexasphere = new Hexasphere(_radius, _divisions, _hexSize);

        _surfaceTool.Clear();
        _surfaceTool.Begin(Mesh.PrimitiveType.Triangles);
        foreach (var v in _hexasphere.MeshDetails.Vertices)
        {
            _surfaceTool.AddVertex(v);
        }

        foreach (var idx in _hexasphere.MeshDetails.Triangles)
        {
            _surfaceTool.AddIndex(idx);
        }

        _surfaceTool.GenerateNormals();
        _meshIns.Mesh = _surfaceTool.Commit();
    }
}