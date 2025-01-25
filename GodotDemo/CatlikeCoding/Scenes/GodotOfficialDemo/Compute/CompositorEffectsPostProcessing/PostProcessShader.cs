using CatlikeCodingFS.GodotOfficialDemo.CompositorEffectsPostProcessing;
using Godot;

namespace CatlikeCodingCSharp.Scenes.GodotOfficialDemo.Compute.CompositorEffectsPostProcessing;

[Tool]
[GlobalClass]
#pragma warning disable GD0401
public partial class PostProcessShader : PostProcessShaderFS // FS 继承了 CompositorEffect -> Resource
#pragma warning restore GD0401
{
    private string _shaderCode;

    [Export(PropertyHint.MultilineText)]
    public override string ShaderCode
    {
        get => _shaderCode;
        set
        {
            Mutex.Lock();
            _shaderCode = value;
            ShaderIsDirty = true;
            Mutex.Unlock();
        }
    }

    public PostProcessShader() => Init();

    // 需要忽略 IDE 省略 partial、_RenderCallback 等的提示，必须保留它们
    public override void _RenderCallback(int effectCallbackType, RenderData renderData) =>
        base._RenderCallback(effectCallbackType, renderData);

    public override void _Notification(int what) => base._Notification(what);
}