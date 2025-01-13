using Godot;
using Godot.Collections;
using ProceduralPlanet.Scripts.Utils;

namespace ProceduralPlanet.Scripts.Planet.Shape.Modules;

[Tool]
[GlobalClass]
public partial class PerturbPointsModule : PerturbModule
{
    private RenderingDevice _rd = RenderingServer.CreateLocalRenderingDevice();

    public override Vector3[] Run(Vector3[] vertices, float maxPerturbStrength)
    {
        // 加载 GLSL 着色器
        var shaderFile = GD.Load("res://Materials/Shaders/Compute/PerturbPoints.glsl") as RDShaderFile;
        var shaderSpirV = shaderFile?.GetSpirV();
        var shader = _rd.ShaderCreateFromSpirV(shaderSpirV);
        // 准备顶点字节数组
        var verticesBytes = ConvertUtils.Vec3ArrToBytes(vertices);
        // 准备我们的参数数据
        var param = new[] { vertices.Length, maxPerturbStrength };
        var paramsBytes = ConvertUtils.FloatsToBytes(param);
        
        // 创建顶点存储缓冲区，vec3 * numVertices，设定 vec3 = float * 3
        var verticesBuffer = _rd.StorageBufferCreate((uint)(4 * 3 * vertices.Length), verticesBytes);
        var uniformVertices = new RDUniform();
        uniformVertices.UniformType = RenderingDevice.UniformType.StorageBuffer;
        uniformVertices.Binding = 0;
        uniformVertices.AddId(verticesBuffer);
        // 创建参数存储缓冲区 TODO: 应该是 uniform 缓冲区？
        var paramsBuffer = _rd.StorageBufferCreate(4 * 2, paramsBytes);
        var uniformParams = new RDUniform();
        uniformParams.UniformType = RenderingDevice.UniformType.StorageBuffer;
        uniformParams.Binding = 1;
        uniformParams.AddId(paramsBuffer);
        var uniformSet =
            _rd.UniformSetCreate(
                new Array<RDUniform>(new[] { uniformVertices, uniformParams }),
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
        
        var outputBytes = _rd.BufferGetData(verticesBuffer);
        var output = ConvertUtils.BytesToFloats(outputBytes);
        for (var i = 0; i < vertices.Length; i++)
        {
            vertices[i].X = output[i * 3];
            vertices[i].Y = output[i * 3 + 1];
            vertices[i].Z = output[i * 3 + 2];
        }

        return vertices;
    }
}