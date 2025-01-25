using CatlikeCodingFS.GodotOfficialDemo.ComputeTexture;
using Godot;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo.Compute.ComputeTexture;

[Tool]
public partial class WaterPlane : WaterPlaneFS
{
    [Export] public override float RainSize { get; set; } = 3f;
    [Export] public override float MouseSize { get; set; } = 5f;
    [Export] public override Vector2I TextureSize { get; set; } = new(512, 512);

    [Export(PropertyHint.Range, "1.0, 10.0, 0.1")]
    public override float Damp { get; set; } = 1f;

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _ExitTree() => base._ExitTree();
    public override void _UnhandledInput(InputEvent @event) => base._UnhandledInput(@event);
    public override void _Process(double delta) => base._Process(delta);
}