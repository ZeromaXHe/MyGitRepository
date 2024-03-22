using Godot;
using System;

public partial class Lesson4Fire : Node2D
{
    private Sprite2D _sprite;
    private ColorPicker _colorPicker;

    public override void _Ready()
    {
        _sprite = GetNode<Sprite2D>("Fire");
        _colorPicker = GetNode<ColorPicker>("ColorPicker");

        GD.Print("Fire:" + _sprite);
        GD.Print("ColorPicker:" + _colorPicker);
        _colorPicker.ColorChanged += ColorPickerColorChanged;
    }

    private void ColorPickerColorChanged(Color color)
    {
        // GD.Print("color changed: " + color);
        (_sprite.Material as ShaderMaterial).SetShaderParameter("ColorParameter", color);
    }
}
