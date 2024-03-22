using Godot;
using System;
using Array = Godot.Collections.Array;

public partial class Slot : TextureRect
{
    [Export(PropertyHint.Enum, "Red,Green")]
    private int type = 0;

    public override bool _CanDropData(Vector2 atPosition, Variant data)
    {
        var arr = (Array)data;
        return (int)arr[1] == type;
    }

    public override void _DropData(Vector2 atPosition, Variant data)
    {
        var arr = (Array)data;
        var textureRect = (TextureRect)arr[0];
        textureRect.GetParent().RemoveChild(textureRect);
        textureRect.Position = Vector2.Zero;
        AddChild(textureRect);
    }
}