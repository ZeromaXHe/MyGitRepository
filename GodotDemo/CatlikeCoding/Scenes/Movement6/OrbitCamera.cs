using CatlikeCodingFS.Movement6;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Movement6;

public partial class OrbitCamera : OrbitCameraFS
{
    [Export] public override PhysicsBody3D Focus { get; set; }
    [Export] public override ShapeCast3D FocusShapeCast { get; set; }
    [Export(PropertyHint.Range, "1, 20")] public override float Distance { get; set; } = 5f;
    [Export(PropertyHint.Range, "0, 100")] public override float FocusRadius { get; set; } = 1f;
    [Export(PropertyHint.Range, "0, 1")] public override float FocusCentering { get; set; } = 0.5f;
    [Export(PropertyHint.Range, "1, 360")] public override float RotationSpeed { get; set; } = 90f;

    [Export(PropertyHint.Range, "-89, 89")]
    public override float MinVerticalAngle { get; set; } = -60f;

    [Export(PropertyHint.Range, "-89, 89")]
    public override float MaxVerticalAngle { get; set; } = 30f;

    [Export(PropertyHint.Range, "0, 100")] public override double AlignDelay { get; set; } = 5;
    [Export(PropertyHint.Range, "0, 90")] public override float AlignSmoothRange { get; set; } = 45f;

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _Process(double delta) => base._Process(delta);
}