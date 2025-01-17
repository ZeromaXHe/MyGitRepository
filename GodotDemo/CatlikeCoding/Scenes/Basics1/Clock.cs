using CatlikeCodingFS.Basics1;
using Godot;

namespace CatlikeCodingCSharp.Scenes.Basics1;

[Tool]
public partial class Clock : ClockFS
{
    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    [Export] public override Node3D HoursPivot { get; set; }
    [Export] public override Node3D MinutesPivot { get; set; }
    [Export] public override Node3D SecondsPivot { get; set; }

    public override void _Ready() => base._Ready();
    public override void _Process(double delta) => base._Process(delta);
}