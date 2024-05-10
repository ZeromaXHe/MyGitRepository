using Godot;
using System;

public partial class LandingPad : CsgBox3D
{
    [Export(PropertyHint.File, "*.tscn")] private String _filePath;
}
