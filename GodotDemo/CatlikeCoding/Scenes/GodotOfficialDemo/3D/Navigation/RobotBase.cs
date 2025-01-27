using System;
using CatlikeCodingFS.GodotOfficialDemo._3D.Navigation;
using Godot;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo._3D.Navigation;

public partial class RobotBase : RobotBaseFS
{
    [Export] public override float CharacterSpeed { get; set; } = 10f;
    [Export] public override bool ShowPath { get; set; } = true;
    public override Func<Line3dFS> Line3dInitiator => () => new Line3D();

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _PhysicsProcess(double delta) => base._PhysicsProcess(delta);
}