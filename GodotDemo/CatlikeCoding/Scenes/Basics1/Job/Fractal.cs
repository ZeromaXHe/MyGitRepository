using CatlikeCodingFS.Basics1;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Basics1.Job;

[Tool]
public partial class Fractal : FractalFS
{
    [Export(PropertyHint.Range, "1, 8")] public override int Depth { get; set; } = 4;
    [Export] public override Mesh MeshF { get; set; }
    [Export] public override Material MaterialF { get; set; }

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _Process(double delta) => base._Process(delta);
}