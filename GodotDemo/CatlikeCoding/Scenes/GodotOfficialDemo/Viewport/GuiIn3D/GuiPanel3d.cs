using CatlikeCodingFS.GodotOfficialDemo.Viewport.GuiIn3D;
using Godot;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo.Viewport.GuiIn3D;

public partial class GuiPanel3D : GuiPanel3dFS
{
    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _Process(double delta) => base._Process(delta);
    public override void _UnhandledInput(InputEvent @event) => base._UnhandledInput(@event);
}