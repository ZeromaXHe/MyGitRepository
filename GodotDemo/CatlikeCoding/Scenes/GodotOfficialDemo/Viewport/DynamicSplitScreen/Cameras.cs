using CatlikeCodingFS.GodotOfficialDemo.Viewport.DynamicSplitScreen;
using Godot;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo.Viewport.DynamicSplitScreen;

public partial class Cameras : CamerasFS
{
    [Export] public override float MaxSeparation { get; set; } = 20f;
    [Export] public override float SplitLineThickness { get; set; } = 3f;
    [Export] public override Color SplitLineColor { get; set; } = Colors.Black;
    [Export] public override bool AdaptiveSplitLineThickness { get; set; } = true;

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _Process(double delta) => base._Process(delta);
}