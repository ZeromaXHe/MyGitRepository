using CatlikeCodingFS.GodotOfficialDemo._3D.Waypoints;
using Godot;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo._3D.Waypoints;

public partial class Waypoint : WaypointFS
{
    private string _text;

    [Export]
    public override string Text
    {
        get => _text;
        set
        {
            _text = value;
            if (IsInsideTree())
                Label.Text = value;
        }
    }

    [Export] public override bool Sticky { get; set; }

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _Process(double delta) => base._Process(delta);
}