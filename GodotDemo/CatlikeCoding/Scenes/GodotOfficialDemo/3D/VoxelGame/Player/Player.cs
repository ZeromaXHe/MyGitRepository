using CatlikeCodingFS.GodotOfficialDemo._3D.VoxelGame;
using Godot;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo._3D.VoxelGame.Player;

public partial class Player : PlayerFS
{
    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _Process(double delta) => base._Process(delta);
    public override void _PhysicsProcess(double delta) => base._PhysicsProcess(delta);
    public override void _Input(InputEvent @event) => base._Input(@event);
}