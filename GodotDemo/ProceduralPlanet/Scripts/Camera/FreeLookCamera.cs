using System;
using Godot;

namespace ProceduralPlanet.Scripts.camera;

public partial class FreeLookCamera : Camera3D
{
    [Export(PropertyHint.Range, "0, 10, 0.01")]
    public float Sensitivity { get; set; } = 3f;

    [Export(PropertyHint.Range, "0, 1000, 0.1")]
    public float DefaultVelocity { get; set; } = 5f;

    [Export(PropertyHint.Range, "0, 10, 0.01")]
    public float SpeedScale { get; set; } = 1.17f;

    [Export] public float MaxSpeed { get; set; } = 1000f;

    [Export] public float MinSpeed { get; set; } = 0.2f;

    private float _velocity;
    public override void _Ready() => _velocity = DefaultVelocity;

    public override void _Input(InputEvent @event)
    {
        if (!Current)
            return;
        if (Input.GetMouseMode() == Input.MouseModeEnum.Captured && @event is InputEventMouseMotion motion)
        {
            var rot = Rotation;
            rot.Y -= motion.Relative.X / 1000 * Sensitivity;
            rot.X -= motion.Relative.Y / 1000 * Sensitivity;
            rot.X = Mathf.Clamp(rot.X, Mathf.Pi / -2, Mathf.Pi / 2);
            Rotation = rot;
        }

        if (@event is InputEventMouseButton button)
        {
            switch (button.ButtonIndex)
            {
                case MouseButton.Right:
                    Input.SetMouseMode(button.Pressed ? Input.MouseModeEnum.Captured : Input.MouseModeEnum.Visible);
                    break;
                case MouseButton.WheelUp:
                    _velocity = Mathf.Clamp(_velocity * SpeedScale, MinSpeed, MaxSpeed);
                    break;
                case MouseButton.WheelDown:
                    _velocity = Mathf.Clamp(_velocity / SpeedScale, MinSpeed, MaxSpeed);
                    break;
            }
        }
    }

    public override void _Process(double delta)
    {
        var direction = new Vector3(
                (Input.IsKeyPressed(Key.D) ? 1f : 0f) - (Input.IsKeyPressed(Key.A) ? 1f : 0f),
                (Input.IsKeyPressed(Key.E) ? 1f : 0f) - (Input.IsKeyPressed(Key.Q) ? 1f : 0f),
                (Input.IsKeyPressed(Key.S) ? 1f : 0f) - (Input.IsKeyPressed(Key.W) ? 1f : 0f))
            .Normalized();
        Translate(direction * _velocity * (float)delta);
    }
}