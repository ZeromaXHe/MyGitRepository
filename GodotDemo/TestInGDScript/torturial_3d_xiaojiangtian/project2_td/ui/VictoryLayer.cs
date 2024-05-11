using Godot;
using System;

public partial class VictoryLayer : CanvasLayer
{
    private TextureRect _star1;
    private TextureRect _star2;
    private TextureRect _star3;
    private Label _healthLabel;
    private Label _moneyLabel;
    private Base _base;
    private Bank _bank;

    public override void _Ready()
    {
        _star1 = GetNode<TextureRect>("%Star1");
        _star2 = GetNode<TextureRect>("%Star2");
        _star3 = GetNode<TextureRect>("%Star3");
        _healthLabel = GetNode<Label>("%HealthLabel");
        _moneyLabel = GetNode<Label>("%MoneyLabel");
        _base = GetTree().GetFirstNodeInGroup("Base") as Base;
        _bank = GetTree().GetFirstNodeInGroup("Bank") as Bank;
    }

    public void Victory()
    {
        Show();
        if (_base.MaxHealth == _base.CurrentHealth)
        {
            _star2.Modulate = Colors.White;
            _healthLabel.Show();
        }

        if (_bank.Gold >= 500)
        {
            _star3.Modulate = Colors.White;
            _moneyLabel.Show();
        }
    }

    private void _OnRetryButtonPressed()
    {
        GetTree().ReloadCurrentScene();
    }

    private void _OnQuitButtonPressed()
    {
        GetTree().Quit();
    }
}