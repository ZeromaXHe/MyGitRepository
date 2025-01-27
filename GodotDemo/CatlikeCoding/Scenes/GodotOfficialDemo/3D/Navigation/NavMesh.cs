using CatlikeCodingFS.GodotOfficialDemo._3D.Navigation;
using Godot;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo._3D.Navigation;

public partial class NavMesh : NavMeshFS
{
    // 需要忽略 IDE 省略 partial、_UnhandledInput 等的提示，必须保留它们
    public override void _UnhandledInput(InputEvent @event) => base._UnhandledInput(@event);
}