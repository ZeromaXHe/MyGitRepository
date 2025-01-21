using CatlikeCodingFS.Movement6;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Movement6;

[Tool]
public partial class MovingSphere : MovingSphereFS
{
    [Export(PropertyHint.Range, "0, 100")] public override float MaxSpeed { get; set; } = 10f;
    [Export(PropertyHint.Range, "0, 100")] public override float MaxAcceleration { get; set; } = 10f;
    [Export] public override Rect2 AllowedArea { get; set; } = new(-11.75f, -11.75f, 24f, 24f);
    [Export(PropertyHint.Range, "0, 1")] public override float Bounciness { get; set; } = 0.5f;

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _Process(double delta) => base._Process(delta);
}