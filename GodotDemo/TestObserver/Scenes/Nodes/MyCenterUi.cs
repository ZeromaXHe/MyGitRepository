using System.Reflection;
using System.Runtime.Loader;
using Godot;

namespace TerraObserver.Scenes.Nodes;

[Tool]
public partial class MyCenterUi : CenterContainer, ISerializationListener
{
    public MyCenterUi()
    {
        GD.Print("MyCenterUi _Init");
        var context = AssemblyLoadContext.GetLoadContext(Assembly.GetExecutingAssembly())!;
        context.Unloading += _ => GD.Print("MyCenterUi AssemblyLoadContext Unloading");
    }

    public override void _EnterTree()
    {
        GD.Print("MyCenterUi _EnterTree");
    }

    public override void _ExitTree()
    {
        GD.Print("MyCenterUi _ExitTree");
    }

    public override void _Ready()
    {
        GD.Print("MyCenterUi _Ready");
    }

    public override void _Notification(int what)
    {
        switch (what)
        {
            case (int)NotificationPredelete:
                GD.Print("MyCenterUi _Notification Pre-delete");
                break;
        }
    }

    public void OnBeforeSerialize()
    {
        GD.Print("MyCenterUi OnBeforeSerialize");
    }

    public void OnAfterDeserialize()
    {
        GD.Print("MyCenterUi OnAfterDeserialize");
    }
}