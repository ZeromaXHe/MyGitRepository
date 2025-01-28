using CatlikeCodingFS.GodotOfficialDemo.Viewport._3dScaling;
using Godot;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo.Viewport._3dScaling;

public partial class Scaling3dHud : Scaling3dHudFS
{
    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _UnhandledInput(InputEvent @event) => base._UnhandledInput(@event);
}