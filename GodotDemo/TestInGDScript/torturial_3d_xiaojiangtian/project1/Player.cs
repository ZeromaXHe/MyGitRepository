using Godot;
using System;

public partial class Player : RigidBody3D
{
    /**
     * 这是一个助推力
     */
    [Export(PropertyHint.Range, "300.0,2000.0")]
    private float _thrust = 1000.0f;

    /**
     * 这是一个扭矩力
     */
    [Export(PropertyHint.Range, "30.0,200.0")]
    private float _torqueThrust = 100.0f;

    private bool _isTransitioning = false;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        if (Input.IsActionPressed("ui_accept"))
        {
            // 普通 Node3D 可以这样控制
            // Position += new Vector3(0, (float)delta, 0);
            // 刚体 RigidBody3D 需要这样
            ApplyCentralForce(Basis.Y * (float)delta * _thrust);
        }

        if (Input.IsActionPressed("ui_left"))
        {
            // 普通 Node3D 可以这样控制
            // RotateZ((float)delta);
            // 刚体 RigidBody3D 需要这样
            ApplyTorque(new Vector3(0.0f, 0.0f, _torqueThrust * (float)delta));
        }

        if (Input.IsActionPressed("ui_right"))
        {
            // 普通 Node3D 可以这样控制
            // RotateZ(-(float)delta);
            // 刚体 RigidBody3D 需要这样
            ApplyTorque(new Vector3(0.0f, 0.0f, -_torqueThrust * (float)delta));
        }
    }

    public void OnBodyEntered(Node body)
    {
        if (_isTransitioning)
        {
            return;
        }
        if (body.GetGroups().Contains("Goal"))
        {
            CompleteLevel(body.Get("_filePath").AsString());
        }

        if (body.GetGroups().Contains("Hazard"))
        {
            CrashSequence();
        }
    }

    private void CrashSequence()
    {
        GD.Print("You crashed! Boom!");
        SetProcess(false);
        _isTransitioning = true;
        var tween = CreateTween();
        tween.TweenInterval(1.0);
        tween.TweenCallback(Callable.From(() => GetTree().ReloadCurrentScene()));
    }

    private void CompleteLevel(string nextSceneFile)
    {
        GD.Print("You win!");
        SetProcess(false);
        _isTransitioning = true;
        var tween = CreateTween();
        tween.TweenInterval(1.0);
        tween.TweenCallback(Callable.From(() => GetTree().ChangeSceneToFile(nextSceneFile)));
    }
}