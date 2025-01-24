using CatlikeCodingFS.Movement6;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Movement6.Gravity;

public partial class GravityBox : GravityBoxFS
{
    [Export] public override float Gravity { get; set; } = 9.81f;
    [Export] public override Vector3 BoundaryDistance { get; set; } = Vector3.One;

    [Export(PropertyHint.Range, "0, 10000")]
    public override float InnerDistance { get; set; }

    [Export(PropertyHint.Range, "0, 10000")]
    public override float InnerFalloffDistance { get; set; }

    [Export(PropertyHint.Range, "0, 10000")]
    public override float OuterDistance { get; set; }

    [Export(PropertyHint.Range, "0, 10000")]
    public override float OuterFalloffDistance { get; set; }

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _ExitTree() => base._ExitTree();
}