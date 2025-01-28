using CatlikeCodingFS.GodotOfficialDemo.Viewport._2Din3D;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo.Viewport._2dIn3D;

public partial class Pong : PongFS
{
    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _Process(double delta) => base._Process(delta);
}