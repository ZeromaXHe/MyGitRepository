using System.Reflection;
using System.Runtime.Loader;
using Godot;

namespace TerraObserver.Scenes.Nodes;

[Tool]
public partial class TestGui : Control, ISerializationListener
{
    public TestGui()
    {
        GD.Print("TestGui _Init");
        var context = AssemblyLoadContext.GetLoadContext(Assembly.GetExecutingAssembly())!;
        context.Unloading += _ => GD.Print("TestGui AssemblyLoadContext Unloading");
    }

    public override void _EnterTree()
    {
        GD.Print("TestGui _EnterTree");
    }

    public override void _Ready()
    {
        GD.Print("TestGui _Ready");
        if (GlobalNode.Instance != null) GlobalNode.Instance.Count++;
        GD.Print($"TestGui Global Count:{GlobalNode.Instance?.Count}");
    }

    public override void _ExitTree()
    {
        GD.Print("TestGui _ExitTree");
    }

    public override void _Notification(int what)
    {
        switch (what)
        {
            case (int)NotificationPredelete:
                GD.Print("TestGui _Notification Pre-delete");
                break;
        }
    }

    public void OnBeforeSerialize()
    {
        GD.Print("TestGui OnBeforeSerialize");
    }

    public void OnAfterDeserialize()
    {
        GD.Print("TestGui OnAfterDeserialize");
    }
}