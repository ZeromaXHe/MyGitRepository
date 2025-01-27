namespace CatlikeCodingFS.GodotOfficialDemo._3D.TruckTown

open Godot

type CameraType =
    | EXTERIOR = 0
    | INTERIOR = 1
    | TOP_DOWN = 2
    | MAX = 3 // 代表 CameraType 枚举的大小

[<AbstractClass>]
type FollowCameraFS() =
    inherit Camera3D()

    // 较高的值会导致视野在高速下增加更多。
    let FOV_SPEED_FACTOR = 60f
    // 较高的值会导致视野更快地适应速度变化。
    let FOV_SMOOTH_FACTOR = 0.2f
    // 如果移动速度低于此速度，请不要更改 FOV。这可以防止在慢速行驶时出现阴影闪烁。
    let FOV_CHANGE_MIN_SPEED = 0.05f

    let mutable cameraType = CameraType.EXTERIOR
    let mutable initialTransform = Transform3D.Identity
    let mutable baseFov = 0f
    // 要平滑插值的视野。
    let mutable desiredFov = 0f
    let mutable previousPosition = Vector3.Zero

    abstract MinDistance: float32 with get, set
    abstract MaxDistance: float32 with get, set
    abstract AngleVAdjust: float32 with get, set
    abstract Height: float32 with get, set

    member this.UpdateCamera() =
        match cameraType with
        | CameraType.EXTERIOR -> this.Transform <- initialTransform
        | CameraType.INTERIOR ->
            this.GlobalTransform <- (this.GetNode<Marker3D> "../../InteriorCameraPosition").GlobalTransform
        | CameraType.TOP_DOWN ->
            this.GlobalTransform <- (this.GetNode<Marker3D> "../../TopDownCameraPosition").GlobalTransform
        | _ -> ()
        // 这会将摄像机变换与父空间节点分离，但仅适用于外部和自上而下的摄像机。
        this.SetAsTopLevel(cameraType <> CameraType.INTERIOR)

    override this._Ready() =
        initialTransform <- this.Transform
        baseFov <- this.Fov
        desiredFov <- this.Fov
        previousPosition <- this.GlobalPosition
        this.UpdateCamera()

    override this._Input(event) =
        if event.IsActionPressed "crouch" then
            cameraType <- enum<CameraType> <| Mathf.Wrap(int cameraType + 1, 0, int CameraType.MAX)
            this.UpdateCamera()

    override this._PhysicsProcess _ =
        if cameraType = CameraType.EXTERIOR then
            let target = this.GetParent<Node3D>().GlobalTransform.Origin
            let mutable pos = this.GlobalTransform.Origin
            let mutable fromTarget = pos - target
            // 检查范围
            if fromTarget.Length() < this.MinDistance then
                fromTarget <- fromTarget.Normalized() * this.MinDistance
            elif fromTarget.Length() > this.MaxDistance then
                fromTarget <- fromTarget.Normalized() * this.MaxDistance

            fromTarget.Y <- this.Height
            pos <- target + fromTarget
            this.LookAtFromPosition(pos, target, Vector3.Up)
        elif cameraType = CameraType.TOP_DOWN then
            let mutable position = this.Position
            position.X <- this.GetParent<Node3D>().GlobalTransform.Origin.X
            position.Z <- this.GetParent<Node3D>().GlobalTransform.Origin.Z
            this.Position <- position
            // 强制旋转以防止在斜坡上切换摄像机后摄像机倾斜。
            this.RotationDegrees <- Vector3(270f, 180f, 0f)
        // 基于车速的动态视野，具有平滑功能，可防止撞击时突然变化。
        desiredFov <-
            Mathf.Clamp(
                baseFov
                + (Mathf.Abs(this.GlobalPosition.Length() - previousPosition.Length())
                   - FOV_CHANGE_MIN_SPEED)
                  * FOV_SPEED_FACTOR,
                baseFov,
                100f
            )

        this.Fov <- Mathf.Lerp(this.Fov, desiredFov, FOV_SMOOTH_FACTOR)
        // 上下转一点
        let mutable trans = this.Transform

        trans.Basis <-
            Basis(this.Transform.Basis[0], Mathf.DegToRad this.AngleVAdjust)
            * this.Transform.Basis

        this.Transform <- trans
        previousPosition <- this.GlobalPosition
