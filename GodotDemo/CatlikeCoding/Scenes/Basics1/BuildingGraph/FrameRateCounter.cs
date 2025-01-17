using CatlikeCodingFS.Basics1;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Basics1.BuildingGraph;

public partial class FrameRateCounter : FrameRateCounterFS
{
    [Export] public override Label Display { get; set; }
    [Export] public override DisplayMode DisplayMode { get; set; } = DisplayMode.FPS;
    [Export(PropertyHint.Range, "0.1, 2")] public override double SampleDuration { get; set; } = 1f;

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Process(double delta) => base._Process(delta);
}