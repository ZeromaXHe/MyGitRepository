using CatlikeCodingFS.Movement6;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Movement6;

public partial class MovingSphere : MovingSphereFS
{
    [Export(PropertyHint.Range, "0, 100")] public override float MaxSpeed { get; set; } = 10f;
    [Export(PropertyHint.Range, "0, 100")] public override float MaxAcceleration { get; set; } = 10f;
    [Export(PropertyHint.Range, "0, 100")] public override float MaxAirAcceleration { get; set; } = 1f;
    [Export(PropertyHint.Range, "0, 10")] public override float JumpHeight { get; set; } = 2f;
    [Export(PropertyHint.Range, "0, 5")] public override int MaxAirJumps { get; set; }
    [Export(PropertyHint.Range, "0, 90")] public override float MaxGroundAngle { get; set; } = 25f;
    [Export(PropertyHint.Range, "0, 100")] public override float MaxSnapSpeed { get; set; } = 100f;

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _Process(double delta) => base._Process(delta);
    public override void _PhysicsProcess(double delta) => base._PhysicsProcess(delta);
    public override void _IntegrateForces(PhysicsDirectBodyState3D state) => base._IntegrateForces(state);
}