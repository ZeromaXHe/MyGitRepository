using CatlikeCodingFS.GodotOfficialDemo._3D.TruckTown;
using Godot;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo._3D.TruckTown.Town;

public partial class TownScene : TownSceneFS
{
    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Input(InputEvent @event) => base._Input(@event);
}