using Godot;
using System;

public partial class Lesson2Dissolve : Node2D
{
    private Sprite2D _sprite;
    private HSlider _slider;

    public override void _Ready()
    {
        _sprite = GetNode<Sprite2D>("Icon");
        _slider = GetNode<HSlider>("HSlider");

        _slider.ValueChanged += SliderValueChanged;
    }

    private void SliderValueChanged(double value)
    {
        (_sprite.Material as ShaderMaterial).SetShaderParameter("FloatParameter", value);
    }
}
