using Godot;
using System;
using Array = Godot.Collections.Array;

public partial class DragObject : TextureRect
{
    [Export(PropertyHint.Enum, "Red,Green")]
    private int type = 0;

    public override Variant _GetDragData(Vector2 atPosition)
    {
        var prev = new TextureRect();
        prev.Texture = Texture;
        SetDragPreview(prev);

        var arr = new Array();
        arr.Add(this);
        arr.Add(type);
        return arr;
    }
}