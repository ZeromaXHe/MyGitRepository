using CatlikeCodingFS.GodotOfficialDemo._3D.VoxelGame;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo._3D.VoxelGame.Menu;

public partial class Debug : DebugFS
{
    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready() => base._Ready();
    public override void _Process(double delta) => base._Process(delta);
}