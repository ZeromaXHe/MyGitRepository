using CatlikeCodingFS.GodotOfficialDemo.CompositorEffectsPostProcessing;
using Godot;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo.Compute.CompositorEffectsPostProcessing;

public partial class CompositorEffects : CompositorEffectsFS
{
    // 需要忽略 IDE 省略 partial、_Input 等的提示，必须保留它们
    public override void _Input(InputEvent @event) => base._Input(@event);
}