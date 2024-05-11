using Godot;
using System;
using System.Diagnostics;

public partial class Base : Node3D
{
    [Export] private int _maxHealth = 5;

    private Label3D _label3D;

    private int _currentHealth;

    public int CurrentHealth
    {
        get => _currentHealth;
        set
        {
            _currentHealth = value;
            _label3D.Text = _currentHealth + "/" + _maxHealth;
            _label3D.Modulate = Colors.Red.Lerp(Colors.White, (float)_currentHealth / _maxHealth);
            GD.Print("health was changed");
            if (_currentHealth < 1)
            {
                GetTree().ReloadCurrentScene();
            }
        }
    }

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        _label3D = GetNode<Label3D>("Label3D");
        CurrentHealth = _maxHealth;
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }

    public void TakeDamage()
    {
        GD.Print("Damage to base!");
        CurrentHealth -= 1;
    }
}