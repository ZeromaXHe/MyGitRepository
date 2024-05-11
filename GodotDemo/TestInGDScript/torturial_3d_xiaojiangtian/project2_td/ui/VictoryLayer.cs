using Godot;
using System;

public partial class VictoryLayer : CanvasLayer
{
    private void _OnRetryButtonPressed()
    {
        GetTree().ReloadCurrentScene();
    }
    
    private void _OnQuitButtonPressed()
    {
        GetTree().Quit();
    }
}
