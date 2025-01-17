namespace CatlikeCodingFS.ProceduralMeshes3

open System.Collections.Generic
open Godot
open Godot.Collections

[<AbstractClass>]
type SimpleProceduralMeshFS() =
    inherit Node3D()

    let meshByArray () =
        let array = new Array()
        array.Resize(int Mesh.ArrayType.Max) |> ignore
        let vertices = List<Vector3>()
        vertices.Add Vector3.Zero
        vertices.Add Vector3.Right
        vertices.Add Vector3.Up
        vertices.Add Vector3.Right
        vertices.Add Vector3.Up
        vertices.Add <| Vector3(1f, 1f, 0f)
        array[int Mesh.ArrayType.Vertex] <- vertices.ToArray()
        let indices = List<int>() // Godot 围绕方向为正面看过去顺时针（参考 ArrayMesh 类文档）
        indices.Add 0
        indices.Add 2
        indices.Add 1
        indices.Add 3
        indices.Add 4
        indices.Add 5
        array[int Mesh.ArrayType.Index] <- indices.ToArray()
        let normals = List<Vector3>()
        normals.Add Vector3.Back
        normals.Add Vector3.Back
        normals.Add Vector3.Back
        normals.Add Vector3.Back
        normals.Add Vector3.Back
        normals.Add Vector3.Back
        array[int Mesh.ArrayType.Normal] <- normals.ToArray()
        let uvs = List<Vector2>() // Godot uv 的坐标系 y 轴方向向下，原点在左上？
        // 这里这个 UV 把我搞晕了，为啥这样
        // 前三个 uoz\uzo\ouz\ozu\zou\zuo\zur 都不对
        // zru -> zru; ruo -> ozr
        uvs.Add Vector2.Zero //Vector2.Zero
        uvs.Add Vector2.Right //Vector2.Right
        uvs.Add Vector2.Up //Vector2.Up
        uvs.Add Vector2.One
        uvs.Add Vector2.Zero
        uvs.Add Vector2.Right
        array[int Mesh.ArrayType.TexUV] <- uvs.ToArray()
        let tangents = List<float32>()
        // 0
        tangents.Add 1f
        tangents.Add 0f
        tangents.Add 0f
        tangents.Add -1f
        // 1
        tangents.Add 1f
        tangents.Add 0f
        tangents.Add 0f
        tangents.Add -1f
        // 2
        tangents.Add 1f
        tangents.Add 0f
        tangents.Add 0f
        tangents.Add -1f
        // 3
        tangents.Add 1f
        tangents.Add 0f
        tangents.Add 0f
        tangents.Add -1f
        // 4
        tangents.Add 1f
        tangents.Add 0f
        tangents.Add 0f
        tangents.Add -1f
        // 5
        tangents.Add 1f
        tangents.Add 0f
        tangents.Add 0f
        tangents.Add -1f
        array[int Mesh.ArrayType.Tangent] <- tangents.ToArray()
        let mesh = new ArrayMesh()
        mesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, array)
        mesh

    let meshBySurfaceTool () =
        let surfaceTool = new SurfaceTool()
        surfaceTool.Begin(Mesh.PrimitiveType.Triangles)
        surfaceTool.SetNormal Vector3.Back
        surfaceTool.SetTangent <| Plane(1f, 0f, 0f, -1f) // 试过 4 个顶点指定不同的向外方向的切线，但还是会有问题……

        surfaceTool.SetUV Vector2.Zero // Vector2.Up
        surfaceTool.AddVertex Vector3.Zero
        surfaceTool.SetUV Vector2.Right // Vector2.One
        surfaceTool.AddVertex Vector3.Right
        surfaceTool.SetUV Vector2.Up // Vector2.Zero
        surfaceTool.AddVertex Vector3.Up
        surfaceTool.SetUV Vector2.One // Vector2.Right // BUG: 为什么这样四个点配 UV，两个三角形就一定会有一个要 bug……
        surfaceTool.AddVertex <| Vector3(1f, 1f, 0f)
        surfaceTool.AddIndex 0
        surfaceTool.AddIndex 2
        surfaceTool.AddIndex 1
        surfaceTool.AddIndex 1
        surfaceTool.AddIndex 2
        surfaceTool.AddIndex 3
        surfaceTool.Commit()

    let mutable meshIns: MeshInstance3D = null
    let mutable ready = false

    abstract UseSurfaceTool: bool with get, set
    abstract AddedMaterial: Material with get, set

    member this.UpdateMesh() =
        if ready then
            if meshIns = null then
                meshIns <- new MeshInstance3D()
                this.AddChild meshIns

            let mesh =
                if this.UseSurfaceTool then
                    meshBySurfaceTool ()
                else
                    meshByArray ()

            if this.AddedMaterial <> null then
                mesh.SurfaceSetMaterial(0, this.AddedMaterial)

            meshIns.Mesh <- mesh

    override this._Ready() =
        ready <- true
        this.UpdateMesh()
