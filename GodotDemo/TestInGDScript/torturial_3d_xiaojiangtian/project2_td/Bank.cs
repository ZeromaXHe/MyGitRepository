using Godot;
using System;

public partial class Bank : MarginContainer
{
    [Export] private int _startingGold = 150;

    private Label _label;

    private int _gold;

    public int Gold
    {
        get => _gold;
        set
        {
            _gold = Math.Max(value, 0);
            _label.Text = "Gold: " + _gold;
        }
    }
    
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
    {
        _label = GetNode<Label>("Label");

        Gold = _startingGold;
    }

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
