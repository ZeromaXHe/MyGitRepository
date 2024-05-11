using Godot;
using System;

public partial class DifficultyManager : Node
{
    [Signal]
    public delegate void StopSpawnEnemiesEventHandler();

    [Export] private float _gameLength = 30.0f;
    [Export] private Curve _spawnTimeCurve;
    [Export] private Curve _enemyHealthCurve;

    private Timer _timer;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        _timer = GetNode<Timer>("Timer");
        _timer.Start(_gameLength);
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        // GD.Print(GameProcessRatio());
    }

    private float GameProcessRatio()
    {
        return 1.0f - (float)_timer.TimeLeft / _gameLength;
    }

    public float GetSpawnTime()
    {
        return _spawnTimeCurve.Sample(GameProcessRatio());
    }

    public float GetEnemyHealth()
    {
        return _enemyHealthCurve.Sample(GameProcessRatio());
    }

    private void _OnTimerTimeout()
    {
        EmitSignal(SignalName.StopSpawnEnemies);
    }
}