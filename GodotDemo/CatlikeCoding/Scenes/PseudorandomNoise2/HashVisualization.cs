using CatlikeCodingFS.PseudorandomNoise2;
using Godot;

namespace CatlikeCodingCSharp.Scenes.PseudorandomNoise2;

[Tool]
public partial class HashVisualization : HashVisualizationFS
{
    [Export] public override Mesh InstanceMesh { get; set; }
    [Export] public override Material Material { get; set; }
    [Export(PropertyHint.Range, "1, 512")] public override int Resolution { get; set; } = 16;
    [Export] public override int Seed { get; set; }
    [Export(PropertyHint.Range, "-2, 2")] public override float VerticalOffset { get; set; } = 1f;

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    // public override void _Process(double delta) => base._Process(delta);
}