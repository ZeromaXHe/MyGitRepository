using System.Linq;
using Godot;
using Godot.Collections;
using ProceduralPlanet.Scripts.Planet.Settings.NoiseSettings;
using ProceduralPlanet.Scripts.Utils;

namespace ProceduralPlanet.Scripts.Planet.Shape.Modules;

[Tool]
[GlobalClass]
public partial class EarthHeightModule : HeightModule
{
    private SimplexNoiseSettings _continentsNoise;

    [Export]
    public SimplexNoiseSettings ContinentsNoise
    {
        get => _continentsNoise;
        set
        {
            _continentsNoise = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
            _continentsNoise.Changed += OnDataChanged;
        }
    }

    private RidgeNoiseSettings _mountainsNoise;

    [Export]
    public RidgeNoiseSettings MountainsNoise
    {
        get => _mountainsNoise;
        set
        {
            _mountainsNoise = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
            _mountainsNoise.Changed += OnDataChanged;
        }
    }

    private SimplexNoiseSettings _maskNoise;

    [Export]
    public SimplexNoiseSettings MaskNoise
    {
        get => _maskNoise;
        set
        {
            _maskNoise = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
            _maskNoise.Changed += OnDataChanged;
        }
    }

    // 大洲设置
    private float _oceanDepthMultiplier = 5f;

    [Export]
    public float OceanDepthMultiplier
    {
        get => _oceanDepthMultiplier;
        set
        {
            _oceanDepthMultiplier = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
        }
    }

    private float _oceanFloorDepth = 1.5f;

    [Export]
    public float OceanFloorDepth
    {
        get => _oceanFloorDepth;
        set
        {
            _oceanFloorDepth = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
        }
    }

    private float _oceanFloorSmoothing = 0.5f;

    [Export]
    public float OceanFloorSmoothing
    {
        get => _oceanFloorSmoothing;
        set
        {
            _oceanFloorSmoothing = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
        }
    }

    private float _mountainBlend = 1.2f;

    [Export]
    public float MountainBlend
    {
        get => _mountainBlend;
        set
        {
            _mountainBlend = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
        }
    }

    // 创建一个本地渲染设备
    private RenderingDevice _rd = RenderingServer.CreateLocalRenderingDevice();
    private void OnDataChanged() => EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();

    public override float[] Run(RandomNumberGenerator rng, Vector3[] vertices)
    {
        // 加载 GLSL 着色器
        var shaderFile = GD.Load("res://Materials/Shaders/Compute/EarthHeight.glsl") as RDShaderFile;
        var shaderSpirV = shaderFile?.GetSpirV();
        var shader = _rd.ShaderCreateFromSpirV(shaderSpirV);
        // 准备顶点字节数组
        var verticesBytes = ConvertUtils.Vec3ArrToBytes(vertices);
        // 准备高度字节数组
        var heights = new float[vertices.Length];
        var heightsBytes = new byte[vertices.Length * sizeof(float)];
        // 准备我们的参数数据
        var param = new[]
            { vertices.Length, _oceanDepthMultiplier, _oceanFloorDepth, _oceanFloorSmoothing, _mountainBlend };
        var paramsBytes = ConvertUtils.FloatsToBytes(param);
        // 准备我们的噪声参数数据
        var noiseParams = _continentsNoise.GetNoiseParams(rng)
            .Concat(_maskNoise.GetNoiseParams(rng))
            .Concat(_mountainsNoise.GetNoiseParams(rng))
            .ToArray();
        var noiseParamsBytes = ConvertUtils.FloatsToBytes(noiseParams);

        // 创建顶点存储缓冲区，vec3 * numVertices，设定 vec3 = float * 3
        var verticesBuffer = _rd.StorageBufferCreate((uint)(4 * 3 * vertices.Length), verticesBytes);
        var uniformVertices = new RDUniform();
        uniformVertices.UniformType = RenderingDevice.UniformType.StorageBuffer;
        uniformVertices.Binding = 0;
        uniformVertices.AddId(verticesBuffer);
        // 创建高度存储缓冲区，float * numVertices
        var heightsBuffer = _rd.StorageBufferCreate((uint)(4 * heights.Length), heightsBytes);
        var uniformHeights = new RDUniform();
        uniformHeights.UniformType = RenderingDevice.UniformType.StorageBuffer;
        uniformHeights.Binding = 1;
        uniformHeights.AddId(heightsBuffer);
        // 创建参数存储缓冲区
        // TODO: 应该是 uniform 缓冲区？
        var paramsBuffer = _rd.StorageBufferCreate(4 * 5, paramsBytes);
        var uniformParams = new RDUniform();
        uniformParams.UniformType = RenderingDevice.UniformType.StorageBuffer;
        uniformParams.Binding = 2;
        uniformParams.AddId(paramsBuffer);
        // 创建噪声参数存储缓冲区
        // TODO: 应该是 uniform 缓冲区？
        var noiseParamsBuffer = _rd.StorageBufferCreate(4 * 4 * 3 * 3, noiseParamsBytes);
        var uniformNoiseParams = new RDUniform();
        uniformNoiseParams.UniformType = RenderingDevice.UniformType.StorageBuffer;
        uniformNoiseParams.Binding = 3;
        uniformNoiseParams.AddId(noiseParamsBuffer);

        var uniformSet =
            _rd.UniformSetCreate(
                new Array<RDUniform>(new[] { uniformVertices, uniformHeights, uniformParams, uniformNoiseParams }),
                shader, 0);
        // 创建计算流水线
        var pipeline = _rd.ComputePipelineCreate(shader);
        var computeList = _rd.ComputeListBegin();
        _rd.ComputeListBindComputePipeline(computeList, pipeline);
        _rd.ComputeListBindUniformSet(computeList, uniformSet, 0);
        // 计算被舍入划分到大小为 512 的工作组
        _rd.ComputeListDispatch(computeList, (uint)Mathf.CeilToInt(vertices.Length / 512.0f), 1, 1);
        _rd.ComputeListEnd();

        var startTime = Time.GetUnixTimeFromSystem();
        // 提交到 GPU 和等待同步
        _rd.Submit();
        _rd.Sync();
        GD.Print($"EarthHeight 计算着色器耗时 {Time.GetUnixTimeFromSystem() - startTime}");

        // 从缓冲区读回数据
        var outputBytes = _rd.BufferGetData(heightsBuffer);
        var output = ConvertUtils.BytesToFloats(outputBytes);
        return output;
    }
}