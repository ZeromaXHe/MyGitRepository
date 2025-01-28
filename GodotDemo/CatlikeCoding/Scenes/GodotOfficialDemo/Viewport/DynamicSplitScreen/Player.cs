using CatlikeCodingFS.GodotOfficialDemo.Viewport.DynamicSplitScreen;
using Godot;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo.Viewport.DynamicSplitScreen;

public partial class Player : PlayerFS
{
    [Export] public override int PlayerId { get; set; } = 1;
    [Export] public override float WalkSpeed { get; set; } = 2f;

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _PhysicsProcess(double delta) => base._PhysicsProcess(delta);
}