namespace CatlikeCodingFS.GodotOfficialDemo._3D.Navigation

open Godot

type NavMeshFS() =
    inherit Node3D()

    let mutable camRotation = 0f

    member this.Camera = this.GetNode<Camera3D> "CameraBase/Camera3D"
    member this.Robot = this.GetNode<RobotBaseFS> "RobotBase"

    override this._UnhandledInput(event) =
        if event :? InputEventMouseButton then
            let e = event :?> InputEventMouseButton

            if e.ButtonIndex = MouseButton.Left && e.Pressed then
                // 获取导航网格上当前鼠标光标位置的最近点。
                let mouseCursorPosition = e.Position
                let cameraRayLength = 1000f
                let cameraRayStart = this.Camera.ProjectRayOrigin mouseCursorPosition

                let cameraRayEnd =
                    cameraRayStart
                    + this.Camera.ProjectRayNormal mouseCursorPosition * cameraRayLength

                let closestPointOnNavmesh =
                    NavigationServer3D.MapGetClosestPointToSegment(
                        this.GetWorld3D().NavigationMap,
                        cameraRayStart,
                        cameraRayEnd
                    )

                this.Robot.SetTargetPosition closestPointOnNavmesh
        elif event :? InputEventMouseMotion then
            let e = event :?> InputEventMouseMotion

            if
                int e.ButtonMask &&& (int MouseButtonMask.Middle + int MouseButtonMask.Right)
                <> 0
            then
                camRotation <- camRotation + e.Relative.X * 0.005f
                (this.GetNode<Node3D> "CameraBase").SetRotation(Vector3.Up * camRotation)
