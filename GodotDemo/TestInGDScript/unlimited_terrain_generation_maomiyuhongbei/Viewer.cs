using Godot;
using System;

public partial class Viewer : Marker3D
{
    [Export] private int _speed = 14;
    
    private Vector3 _targetVelocity = Vector3.Zero;
    
	public override void _PhysicsProcess(double delta)
    {
        var direction = Vector3.Zero;
        if (Input.IsActionPressed("ui_right"))
        {
            direction.X += 1;
        }
        if (Input.IsActionPressed("ui_left"))
        {
            direction.X -= 1;
        }
        if (Input.IsActionPressed("ui_up"))
        {
            direction.Z -= 1;
        }
        if (Input.IsActionPressed("ui_down"))
        {
            direction.Z += 1;
        }
        if (Input.IsActionPressed("ui_page_up"))
        {
            direction.Y += 1;
        }
        if (Input.IsActionPressed("ui_page_down"))
        {
            direction.Y -= 1;
        }

        if (direction != Vector3.Zero)
        {
            direction = direction.Normalized();
        }

        _targetVelocity.X = direction.X * _speed;
        _targetVelocity.Y = direction.Y * _speed;
        _targetVelocity.Z = direction.Z * _speed;

        GlobalPosition += _targetVelocity * (float)delta;
    }
}
