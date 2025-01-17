using CatlikeCodingFS.ProceduralMeshes3;
using Godot;

namespace CatlikeCodingCSharp.Scenes.ProceduralMeshes3;

[Tool]
public partial class SimpleProceduralMesh : SimpleProceduralMeshFS
{
    private bool _useSurfaceTool = true;

    [Export]
    public override bool UseSurfaceTool
    {
        get => _useSurfaceTool;
        set
        {
            _useSurfaceTool = value;
            UpdateMesh();
        }
    }

    [Export] public override Material AddedMaterial { get; set; }

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
}