using System;
using CatlikeCodingFS.GodotOfficialDemo._3D.VoxelGame;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo._3D.VoxelGame.World;

public partial class VoxelWorld : VoxelWorldFS
{
    // 注意必须这样把 C# Chunk 类传递给 F# 代码，来真正创建 Chunk
    // 直接用 F# 的 new ChunkFS() 时，是不会调用分部类的 _Ready() 逻辑的，就只是创建了普通的 StaticBody3D
    public override Func<ChunkFS> ChunkCsInitiator => () => new Chunk();

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Process(double delta) => base._Process(delta);
}