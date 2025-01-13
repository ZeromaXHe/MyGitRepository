using Godot;

namespace ProceduralPlanet.Scripts.Misc;

public partial class QuickRotate : Node3D
{
    [Export] public float Speed { get; set; } = 0f;
    public override void _Process(double delta) => RotateY((float)delta * Speed * Mathf.Pi / 180f);
}