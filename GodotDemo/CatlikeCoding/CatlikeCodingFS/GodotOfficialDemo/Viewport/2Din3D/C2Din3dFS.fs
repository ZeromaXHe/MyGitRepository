namespace CatlikeCodingFS.GodotOfficialDemo.Viewport._2Din3D

open Godot

type C2Din3dFS() =
    inherit Node3D()
    // 相机空闲缩放效果强度。
    let CAMERA_IDLE_SCALE = 0.005f

    let mutable counter = 0f
    let mutable cameraBaseRotation = Vector3.Zero

    override this._Ready() =
        cameraBaseRotation <- (this.GetNode<Camera3D> "Camera3D").Rotation
        // 清空视口
        let viewport = this.GetNode<SubViewport> "SubViewport"
        viewport.RenderTargetClearMode <- SubViewport.ClearMode.Once
        // 取回纹理并将它设置给视口四边形
        ((this.GetNode<MeshInstance3D> "ViewportQuad").MaterialOverride :?> StandardMaterial3D)
            .AlbedoTexture <- viewport.GetTexture()

    override this._Process delta =
        // 使用“空闲”动画来动画化相机
        counter <- counter + float32 delta
        let cam = this.GetNode<Camera3D> "Camera3D"
        let mutable rot = cam.Rotation
        rot.X <- cameraBaseRotation.Y + Mathf.Cos counter * CAMERA_IDLE_SCALE
        rot.Y <- cameraBaseRotation.Y + Mathf.Sin counter * CAMERA_IDLE_SCALE
        rot.Z <- cameraBaseRotation.Y + Mathf.Sin counter * CAMERA_IDLE_SCALE
        cam.Rotation <- rot
