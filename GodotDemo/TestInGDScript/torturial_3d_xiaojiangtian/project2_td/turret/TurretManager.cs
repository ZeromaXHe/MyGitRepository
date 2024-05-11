using Godot;
using System;

public partial class TurretManager : Node3D
{
    [Export] private PackedScene _turret;
    [Export] private Path3D _enemyPath;

    public void BuildTurret(Vector3 turretPosition)
    {
        var newTurret = _turret.Instantiate() as Turret;
        AddChild(newTurret);
        newTurret.GlobalPosition = turretPosition;
        newTurret.EnemyPath = _enemyPath;
    }
}
