using Godot;
using System;

public partial class RayPickerCamera : Camera3D
{
    [Export] private GridMap _gridMap;
    [Export] private TurretManager _turretManager;
    [Export] private int _turretCost = 100;

    private RayCast3D _rayCast3D;
    private Bank _bank;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        _rayCast3D = GetNode<RayCast3D>("RayCast3D");
        // 这种拿法不知道算不算 Godot 自带的控制反转的方式？
        _bank = GetTree().GetFirstNodeInGroup("Bank") as Bank;
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        var mousePosition = GetViewport().GetMousePosition();
        _rayCast3D.TargetPosition = ProjectLocalRayNormal(mousePosition) * 100.0f;
        _rayCast3D.ForceRaycastUpdate();
        // GD.PrintT(_rayCast3D.GetCollider(), _rayCast3D.GetCollisionPoint());

        if (!_rayCast3D.IsColliding() || _bank.Gold < _turretCost)
        {
            Input.SetDefaultCursorShape();
            return;
        }

        Input.SetDefaultCursorShape(Input.CursorShape.PointingHand);
        var collider = _rayCast3D.GetCollider();
        if (collider is not GridMap || !Input.IsActionPressed("Click"))
        {
            return;
        }

        var colliderPoint = _rayCast3D.GetCollisionPoint();
        var cell = _gridMap.LocalToMap(colliderPoint);
        if (_gridMap.GetCellItem(cell) != 0)
        {
            return;
        }

        _gridMap.SetCellItem(cell, 1);
        var turretPosition = _gridMap.MapToLocal(cell);
        _turretManager.BuildTurret(turretPosition);
        _bank.Gold -= _turretCost;
    }
}