using Godot;
using System;

public partial class EnemyPath : Path3D
{
    [Export] private PackedScene _enemyScene;
    [Export] private CanvasLayer _victoryLayer;

    private DifficultyManager _difficultyManager;
    private Timer _timer;

    public override void _Ready()
    {
        // 教程这样随便拿的吗？
        _difficultyManager = GetNode<DifficultyManager>("../DifficultyManager");
        _timer = GetNode<Timer>("Timer");
    }

    public void SpawnEnemy()
    {
        var newEnemy = _enemyScene.Instantiate() as Enemy;
        newEnemy.MaxHealth = (int)_difficultyManager.GetEnemyHealth();
        AddChild(newEnemy);
        _timer.WaitTime = _difficultyManager.GetSpawnTime();
        newEnemy.TreeExited += EnemyDefeated;
    }

    private void _OnTimerTimeout()
    {
        SpawnEnemy();
    }

    private void _OnDifficultyManagerStopSpawnEnemies()
    {
        _timer.Stop();
    }

    private void EnemyDefeated()
    {
        if (_timer.IsStopped())
        {
            foreach (var child in GetChildren())
            {
                if (child is Enemy)
                {
                    return;
                }
            }

            GD.Print("You win!");
            _victoryLayer.Show();
        }
    }
}