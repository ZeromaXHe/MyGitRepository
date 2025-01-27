namespace CatlikeCodingFS.GodotOfficialDemo._3D.Navigation

open Godot

type Line3dFS() =
    inherit MeshInstance3D()

    member this.DrawPath(path: Vector3 array) =
        let im = this.Mesh :?> ImmediateMesh
        im.ClearSurfaces()
        im.SurfaceBegin(Mesh.PrimitiveType.Points, null)
        im.SurfaceAddVertex path[0]
        im.SurfaceAddVertex path[path.Length - 1]
        im.SurfaceEnd()
        im.SurfaceBegin(Mesh.PrimitiveType.LineStrip, null)

        for currentVector in path do
            im.SurfaceAddVertex currentVector

        im.SurfaceEnd()

    override this._Ready() =
        this.Mesh <- new ImmediateMesh()
        let material = new StandardMaterial3D()
        material.ShadingMode <- BaseMaterial3D.ShadingModeEnum.Unshaded
        this.SetMaterialOverride material
