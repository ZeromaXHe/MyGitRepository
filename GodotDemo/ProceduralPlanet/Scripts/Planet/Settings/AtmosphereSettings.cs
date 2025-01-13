using System;
using Godot;
using Godot.Collections;
using ProceduralPlanet.Scripts.Utils;

namespace ProceduralPlanet.Scripts.Planet.Settings;

[Tool]
[GlobalClass]
public partial class AtmosphereSettings : Resource
{
    private int _textureSize = 256;

    [Export]
    public int TextureSize
    {
        get => _textureSize;
        set
        {
            _textureSize = value;
            OnDataChanged();
        }
    }

    private int _inScatteringPoints = 10;

    [Export]
    public int InScatteringPoints
    {
        get => _inScatteringPoints;
        set
        {
            _inScatteringPoints = value;
            OnDataChanged();
        }
    }

    private int _opticalDepthPoints = 10;

    [Export]
    public int OpticalDepthPoints
    {
        get => _opticalDepthPoints;
        set
        {
            _opticalDepthPoints = value;
            OnDataChanged();
        }
    }

    private float _densityFalloff = 0.25f;

    [Export]
    public float DensityFalloff
    {
        get => _densityFalloff;
        set
        {
            _densityFalloff = value;
            OnDataChanged();
        }
    }

    private Vector3 _waveLengths = new(700, 530, 460);

    [Export]
    public Vector3 WaveLengths
    {
        get => _waveLengths;
        set
        {
            _waveLengths = value;
            OnDataChanged();
        }
    }

    private float _scatteringStrength = 20f;

    [Export]
    public float ScatteringStrength
    {
        get => _scatteringStrength;
        set
        {
            _scatteringStrength = value;
            OnDataChanged();
        }
    }

    private float _intensity = 1f;

    [Export]
    public float Intensity
    {
        get => _intensity;
        set
        {
            _intensity = value;
            OnDataChanged();
        }
    }

    private float _ditherStrength = 0.8f;

    [Export]
    public float DitherStrength
    {
        get => _ditherStrength;
        set
        {
            _ditherStrength = value;
            OnDataChanged();
        }
    }

    private float _ditherScale = 4f;

    [Export]
    public float DitherScale
    {
        get => _ditherScale;
        set
        {
            _ditherScale = value;
            OnDataChanged();
        }
    }

    private float _atmosphereScale = 0.5f;

    [Export(PropertyHint.Range, "0.0, 1.0")]
    public float AtmosphereScale
    {
        get => _atmosphereScale;
        set
        {
            _atmosphereScale = value;
            OnDataChanged();
        }
    }

    private Texture2D _blueNoiseTexture;

    [Export]
    public Texture2D BlueNoiseTexture
    {
        get => _blueNoiseTexture;
        set
        {
            _blueNoiseTexture = value;
            OnDataChanged();
        }
    }

    private RandomNumberGenerator _rng = new();
    private bool _opticalDepthBaked = false;
    [Export] public ImageTexture OpticalDepthTexture = new();
    private RenderingDevice _rd = RenderingServer.CreateLocalRenderingDevice();

    private void OnDataChanged()
    {
        _opticalDepthBaked = false;
        EmitChanged();
    }

    public void SetProperties(ShaderMaterial material, float bodyRadius)
    {
        var atmosphereRadius = (1.0f + _atmosphereScale) * bodyRadius;
        material.SetShaderParameter("NumInScatteringPoints", _inScatteringPoints);
        material.SetShaderParameter("NumOpticalDepthPoints", _opticalDepthPoints);
        material.SetShaderParameter("AtmosphereRadius", atmosphereRadius);
        material.SetShaderParameter("PlanetRadius", bodyRadius);
        material.SetShaderParameter("DensityFalloff", _densityFalloff);
        // Strength of (rayleigh) scattering is inversely proportional to wavelength^4
        var scatterX = Mathf.Pow(400f / _waveLengths.X, 4f);
        var scatterY = Mathf.Pow(400f / _waveLengths.Y, 4f);
        var scatterZ = Mathf.Pow(400f / _waveLengths.Z, 4f);
        material.SetShaderParameter("ScatteringCoefficients",
            new Vector3(scatterX, scatterY, scatterZ) * _scatteringStrength);
        material.SetShaderParameter("Intensity", _intensity);
        material.SetShaderParameter("DitherStrength", _ditherStrength);
        material.SetShaderParameter("DitherScale", _ditherScale);
        material.SetShaderParameter("BlueNoise", _blueNoiseTexture);
        if (!_opticalDepthBaked)
        {
            _opticalDepthBaked = true;
            OpticalDepthCompute();
        }

        material.SetShaderParameter("BakedOpticalDepth", OpticalDepthTexture);
    }

    private void OpticalDepthCompute()
    {
        // 加载 GLSL 着色器
        var shaderFile = GD.Load("res://Materials/Shaders/Compute/AtmosphereTexture.glsl") as RDShaderFile;
        var shaderSpirV = shaderFile?.GetSpirV();
        var shader = _rd.ShaderCreateFromSpirV(shaderSpirV);
        // 准备我们的渲染材质
        var fmt = new RDTextureFormat();
        fmt.Width = (uint)_textureSize;
        fmt.Height = (uint)_textureSize;
        fmt.Format = RenderingDevice.DataFormat.R32G32B32A32Sfloat;
        fmt.UsageBits = RenderingDevice.TextureUsageBits.StorageBit | RenderingDevice.TextureUsageBits.CanUpdateBit |
                        RenderingDevice.TextureUsageBits.CanCopyFromBit;
        fmt.TextureType = RenderingDevice.TextureType.Type2D;
        var view = new RDTextureView();
        var textureBuffer = _rd.TextureCreate(fmt, view);
        // 准备我们的数据。我们在着色器中使用 double，所以我们需要 64 位。
        var inputParams = new[] { _textureSize, _opticalDepthPoints, 1f + _atmosphereScale, _densityFalloff };
        var inputBytes = ConvertUtils.FloatsToBytes(inputParams);

        // 创建 image2D uniform
        var uniformTex = new RDUniform();
        uniformTex.UniformType = RenderingDevice.UniformType.Image;
        uniformTex.Binding = 0;
        uniformTex.AddId(textureBuffer);

        // 创建一个可以装下 4 个浮点数的存储缓冲区
        // 4 字节 * 4 变量
        var buffer = _rd.StorageBufferCreate(4 * 4, inputBytes);
        var uniformParams = new RDUniform();
        uniformParams.UniformType = RenderingDevice.UniformType.StorageBuffer;
        uniformParams.Binding = 1;
        uniformParams.AddId(buffer);

        var uniformSet = _rd.UniformSetCreate(new Array<RDUniform>(new[] { uniformTex, uniformParams }), shader, 0);

        // 创建计算流水线
        var pipeline = _rd.ComputePipelineCreate(shader);
        var computeList = _rd.ComputeListBegin();
        _rd.ComputeListBindComputePipeline(computeList, pipeline);
        _rd.ComputeListBindUniformSet(computeList, uniformSet, 0);
        _rd.ComputeListDispatch(computeList, (uint)Mathf.CeilToInt(_textureSize / 16.0f),
            (uint)Mathf.CeilToInt(_textureSize / 16.0f), 1);
        _rd.ComputeListEnd();

        // 提交到 GPU 和等待同步
        _rd.Submit();
        _rd.Sync();

        // 从缓冲区读回数据
        var outputBytes = _rd.TextureGetData(textureBuffer, 0);
        var img = Image.CreateFromData(_textureSize, _textureSize, false, Image.Format.Rgbaf, outputBytes);
        OpticalDepthTexture = ImageTexture.CreateFromImage(img);
    }
}