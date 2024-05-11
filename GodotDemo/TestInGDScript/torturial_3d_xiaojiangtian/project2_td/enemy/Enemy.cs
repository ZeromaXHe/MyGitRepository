using Godot;
using System;

public partial class Enemy : PathFollow3D
{
    [Export] private float _speed = 2.5f;
    [Export] public int MaxHealth = 50;
    [Export] private int _goldValue = 15;

    private Base _base;
    private Bank _bank;
    private AnimationPlayer _animationPlayer;

    private int _currentHealth;

    public int CurrentHealth
    {
        get => _currentHealth;
        set
        {
            if (value < _currentHealth)
            {
                _animationPlayer.Play("TakeDamage");
            }

            _currentHealth = value;
            if (_currentHealth < 1)
            {
                _bank.Gold += _goldValue;
                QueueFree();
            }
        }
    }

    public override void _Ready()
    {
        _base = GetTree().GetFirstNodeInGroup("Base") as Base;
        _bank = GetTree().GetFirstNodeInGroup("Bank") as Bank;
        _animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");

        _currentHealth = MaxHealth;
        // 游戏加速 3 倍
        Engine.TimeScale = 3;
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        Progress += _speed * (float)delta;
        if (ProgressRatio >= 1.0)
        {
            _base.TakeDamage();
            SetProcess(false);
            QueueFree();
        }
    }
}