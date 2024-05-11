using Godot;
using System;
using System.Linq;

public partial class Turret : Node3D
{
    [Export] private PackedScene _projectile;
    [Export] private float _turretRange = 10.0f;

    private MeshInstance3D _barrel;
    private AnimationPlayer _animationPlayer;

    public Path3D EnemyPath;

    private Enemy _target;

    public override void _Ready()
    {
        _barrel = GetNode<MeshInstance3D>("Base/Top/Visor/Barrel");
        _animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
    }

    public override void _PhysicsProcess(double delta)
    {
        _target = FindBestTarget();
        if (_target == null)
        {
            return;
        }

        LookAt(_target.GlobalPosition, Vector3.Up, true);
    }

    private Enemy FindBestTarget()
    {
        return EnemyPath.GetChildren()
            .OfType<Enemy>()
            .Where(e => GlobalPosition.DistanceTo(e.GlobalPosition) <= _turretRange)
            .MaxBy(e => e.Progress);
    }

    private void _OnTimerTimeout()
    {
        if (_target == null)
        {
            return;
        }

        var shot = _projectile.Instantiate() as Projectile;
        AddChild(shot);
        shot.GlobalPosition = _barrel.GlobalPosition;
        shot.Direction = GlobalTransform.Basis.Z;
        
        _animationPlayer.Play("Fire");
    }
}