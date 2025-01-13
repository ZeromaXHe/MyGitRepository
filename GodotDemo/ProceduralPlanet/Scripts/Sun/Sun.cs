using Godot;
using ProceduralPlanet.Scripts.Planet;

namespace ProceduralPlanet.Scripts.Sun;

[Tool]
public partial class Sun : Node3D
{
    [Export] public Node3D Planet;
    [Export] public float TimeOfDay;
    [Export] public float SunDst = 1f;
    [Export] public float TimeSpeed = 0.01f;

    public override void _Process(double delta)
    {
        if (!Engine.IsEditorHint())
            TimeOfDay += (float)delta * TimeSpeed;
        var globalTrans = GlobalTransform;
        globalTrans.Origin = new Vector3(Mathf.Cos(TimeOfDay), Mathf.Sin(TimeOfDay), 0f) * SunDst;
        GlobalTransform = globalTrans;
        var planetToSun = (GlobalPosition - Planet.GlobalPosition).Normalized();
        var upVector = new Vector3(-planetToSun.Y, planetToSun.X, 0f);
        LookAt(Planet.GlobalPosition, upVector);
    }
}