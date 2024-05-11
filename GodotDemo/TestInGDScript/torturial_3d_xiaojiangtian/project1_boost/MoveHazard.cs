using Godot;
using System;

public partial class MoveHazard : AnimatableBody3D
{
    [Export] private Vector3 _destination;
    [Export] private float _duration = 1.0f;
    
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
    {
        var tween = CreateTween();
        tween.SetLoops();
        tween.SetTrans(Tween.TransitionType.Sine);
        tween.TweenProperty(this, "global_position", GlobalPosition + _destination, _duration);
        tween.TweenProperty(this, "global_position", GlobalPosition, _duration);
    }

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
