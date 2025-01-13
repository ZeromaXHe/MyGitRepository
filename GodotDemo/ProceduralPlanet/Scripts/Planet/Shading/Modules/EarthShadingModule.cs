using System.Linq;
using Godot;
using Godot.Collections;
using ProceduralPlanet.Scripts.Planet.Settings.NoiseSettings;
using ProceduralPlanet.Scripts.Utils;

namespace ProceduralPlanet.Scripts.Planet.Shading.Modules;

[Tool]
[GlobalClass]
public partial class EarthShadingModule : ShadingDataModule
{
    private SimplexNoiseSettings _detailWarpNoise;

    [Export]
    public SimplexNoiseSettings DetailWarpNoise
    {
        get => _detailWarpNoise;
        set
        {
            _detailWarpNoise = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
            _detailWarpNoise.Changed += OnDataChanged;
        }
    }

    private SimplexNoiseSettings _detailNoise;

    [Export]
    public SimplexNoiseSettings DetailNoise
    {
        get => _detailNoise;
        set
        {
            _detailNoise = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
            _detailNoise.Changed += OnDataChanged;
        }
    }

    private SimplexNoiseSettings _largeNoise;

    [Export]
    public SimplexNoiseSettings LargeNoise
    {
        get => _largeNoise;
        set
        {
            _largeNoise = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
            _largeNoise.Changed += OnDataChanged;
        }
    }

    private SimplexNoiseSettings _smallNoise;

    [Export]
    public SimplexNoiseSettings SmallNoise
    {
        get => _smallNoise;
        set
        {
            _smallNoise = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
            _smallNoise.Changed += OnDataChanged;
        }
    }

    // 第二 warp
    private SimplexNoiseSettings _warp2Noise = new();
    private SimplexNoiseSettings _noise2Noise = new();

    // 创建本地渲染设备
    private RenderingDevice _rd = RenderingServer.CreateLocalRenderingDevice();
    private void OnDataChanged() => EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();

    public override Vector2[][] Run(RandomNumberGenerator rng, Vector3[] vertices)
    {
        var shadingData = new float[vertices.Length * 4];
        // 加载 GLSL 着色器
        var shaderFile = GD.Load("res://Materials/Shaders/Compute/EarthShading.glsl") as RDShaderFile;
        var shaderSpirV = shaderFile?.GetSpirV();
        var shader = _rd.ShaderCreateFromSpirV(shaderSpirV);
        // 准备顶点字节数组
        var verticesBytes = ConvertUtils.Vec3ArrToBytes(vertices);
        // 准备着色数据字节数组
        var shadingDataBytes = ConvertUtils.FloatsToBytes(shadingData);
        // 准备我们的参数数据
        var param = new float[] { vertices.Length };
        var paramsBytes = ConvertUtils.FloatsToBytes(param);
        // 准备我们的噪声参数数据
        var noiseParams = _detailWarpNoise.GetNoiseParams(rng)
            .Concat(_detailNoise.GetNoiseParams(rng))
            .Concat(_largeNoise.GetNoiseParams(rng))
            .Concat(_smallNoise.GetNoiseParams(rng))
            .Concat(_warp2Noise.GetNoiseParams(rng))
            .Concat(_noise2Noise.GetNoiseParams(rng))
            .ToArray();
        var noiseParamsBytes = ConvertUtils.FloatsToBytes(noiseParams);

        // 创建顶点存储缓冲区，vec3 * numVertices，设定 vec3 = float * 3
        var verticesBuffer = _rd.StorageBufferCreate((uint)(4 * 3 * vertices.Length), verticesBytes);
        var uniformVertices = new RDUniform();
        uniformVertices.UniformType = RenderingDevice.UniformType.StorageBuffer;
        uniformVertices.Binding = 0;
        uniformVertices.AddId(verticesBuffer);
        // 创建着色数据存储缓冲区，float * 4 * numVertices
        var shadingDataBuffer = _rd.StorageBufferCreate((uint)(4 * 4 * vertices.Length), shadingDataBytes);
        var uniformShadingData = new RDUniform();
        uniformShadingData.UniformType = RenderingDevice.UniformType.StorageBuffer;
        uniformShadingData.Binding = 1;
        uniformShadingData.AddId(shadingDataBuffer);
        // 创建参数存储缓冲区 TODO: 应该是 uniform 缓冲区？
        var paramsBuffer = _rd.StorageBufferCreate(4, paramsBytes);
        var uniformParams = new RDUniform();
        uniformParams.UniformType = RenderingDevice.UniformType.StorageBuffer;
        uniformParams.Binding = 2;
        uniformParams.AddId(paramsBuffer);
        // 创建噪声参数存储缓冲区。vec4 * 6 * 3，vec4 由 4 个浮点数组成
        // TODO: 应该是 uniform 缓冲区？
        var noiseParamsBuffer = _rd.StorageBufferCreate(4 * 4 * 6 * 3, noiseParamsBytes);
        var uniformNoiseParams = new RDUniform();
        uniformNoiseParams.UniformType = RenderingDevice.UniformType.StorageBuffer;
        uniformNoiseParams.Binding = 3;
        uniformNoiseParams.AddId(noiseParamsBuffer);

        var uniformSet =
            _rd.UniformSetCreate(
                new Array<RDUniform>(new[] { uniformVertices, uniformShadingData, uniformParams, uniformNoiseParams }),
                shader, 0);
        // 创建计算流水线
        var pipeline = _rd.ComputePipelineCreate(shader);
        var computeList = _rd.ComputeListBegin();
        _rd.ComputeListBindComputePipeline(computeList, pipeline);
        _rd.ComputeListBindUniformSet(computeList, uniformSet, 0);
        // 计算被舍入划分到大小为 512 的工作组
        _rd.ComputeListDispatch(computeList, (uint)Mathf.CeilToInt(vertices.Length / 512.0f), 1, 1);
        _rd.ComputeListEnd();

        // 提交到 GPU 和等待同步
        _rd.Submit();
        _rd.Sync();

        // 从缓冲区读回数据
        var outputBytes = _rd.BufferGetData(shadingDataBuffer);
        var output = ConvertUtils.BytesToFloats(outputBytes);
        var uv1 = new Vector2[vertices.Length];
        var uv2 = new Vector2[vertices.Length];
        for (var i = 0; i < vertices.Length; i++)
        {
            uv1[i] = new Vector2(output[i * 4], output[i * 4 + 1]);
            uv2[i] = new Vector2(output[i * 4 + 2], output[i * 4 + 3]);
        }

        return [uv1, uv2];
    }
}