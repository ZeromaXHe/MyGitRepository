using CatlikeCodingFS.Basics1;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Basics1.BuildingGraph;

[Tool]
public partial class Graph : GraphFS
{
    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    [Export] public override PackedScene PointPrefab { get; set; }

    [Export(PropertyHint.Range, "10, 100")]
    public override int Resolution { get; set; } = 10;

    public override void _Ready() => base._Ready();
    public override void _Process(double delta) => base._Process(delta);
}