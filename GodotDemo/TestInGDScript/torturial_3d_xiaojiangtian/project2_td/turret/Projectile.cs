using Godot;
using System;

public partial class Projectile : Area3D
{
    [Export] private float _speed = 30.0f;

    public Vector3 Direction = Vector3.Forward;

    public override void _PhysicsProcess(double delta)
    {
        Position += Direction * _speed * (float)delta;
    }

    private void _OnTimerTimeOut()
    {
        QueueFree();
    }

    private void _OnAreaEntered(Area3D area3D)
    {
        if (area3D.IsInGroup("EnemyArea"))
        {
            ((Enemy)area3D.GetParent()).CurrentHealth -= 25;
            QueueFree();
        }
    }
}