using CatlikeCodingFS.GodotOfficialDemo._3D.TruckTown;
using Godot;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo._3D.TruckTown.Vehicles;

public partial class FollowCamera : FollowCameraFS
{
    [Export] public override float MinDistance { get; set; } = 2f;
    [Export] public override float MaxDistance { get; set; } = 4f;
    [Export] public override float AngleVAdjust { get; set; }
    [Export] public override float Height { get; set; } = 1.5f;

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _PhysicsProcess(double delta) => base._PhysicsProcess(delta);
    public override void _Input(InputEvent @event) => base._Input(@event);
}