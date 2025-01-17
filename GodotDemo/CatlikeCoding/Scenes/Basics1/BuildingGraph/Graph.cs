using CatlikeCodingFS.Basics1;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Basics1.BuildingGraph;

[Tool]
public partial class Graph : GraphFS
{
    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    [Export] public override PackedScene PointPrefab { get; set; }
    private bool _useMultiMesh = true;

    [Export]
    public override bool UseMultiMesh
    {
        get => _useMultiMesh;
        set
        {
            _useMultiMesh = value;
            InitGraph();
        }
    }

    private int _resolution = 10;

    [Export(PropertyHint.Range, "10, 100")]
    public override int Resolution
    {
        get => _resolution;
        set
        {
            _resolution = value;
            InitGraph();
        }
    }

    [Export(PropertyHint.Range, "0, 2")] public override FunctionLibrary.FunctionName Function { get; set; }

    [Export(PropertyHint.Range, "0.1, 10000")]
    public override float FunctionDuration { get; set; } = 1f;

    [Export(PropertyHint.Range, "0.1, 10000")]
    public override float TransitionDuration { get; set; } = 1f;

    [Export] public override TransitionMode TransitionMode { get; set; }

    public override void _Ready() => base._Ready();
    public override void _Process(double delta) => base._Process(delta);
}