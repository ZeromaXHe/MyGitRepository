using CatlikeCodingFS.Basics1;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Basics1.Job;

[Tool]
public partial class Fractal : FractalFS
{
    [Export(PropertyHint.Range, "3, 8")] public override int Depth { get; set; } = 4;
    [Export] public override Mesh MeshF { get; set; }
    [Export] public override Mesh LeafMesh { get; set; }
    [Export] public override Material MaterialF { get; set; }
    [Export] public override Gradient GradientA { get; set; }
    [Export] public override Gradient GradientB { get; set; }
    [Export] public override Color LeafColorA { get; set; }
    [Export] public override Color LeafColorB { get; set; }
    [Export(PropertyHint.Range, "0, 90")] public override float MaxSagAngleA { get; set; } = 15f;
    [Export(PropertyHint.Range, "0, 90")] public override float MaxSagAngleB { get; set; } = 25f;
    [Export(PropertyHint.Range, "0, 90")] public override float SpinSpeedA { get; set; } = 20f;
    [Export(PropertyHint.Range, "0, 90")] public override float SpinSpeedB { get; set; } = 25f;
    [Export(PropertyHint.Range, "0, 1")] public override float ReverseSpinChance { get; set; } = 0.25f;

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _Process(double delta) => base._Process(delta);
}