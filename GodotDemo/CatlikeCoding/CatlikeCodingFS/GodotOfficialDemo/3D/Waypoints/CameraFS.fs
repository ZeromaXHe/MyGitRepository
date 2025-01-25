namespace CatlikeCodingFS.GodotOfficialDemo._3D.Waypoints

open Godot

type CameraFS() =
    inherit Camera3D()

    let MOUSE_SENSITIVITY = 0.002f
    let MOVE_SPEED = 0.65f

    let mutable rot = Vector3.Zero
    let mutable velocity = Vector3.Zero

    override this._Ready() =
        Input.MouseMode <- Input.MouseModeEnum.Captured

    override this._Input(event) =
        // 鼠标观察（只在鼠标捕获情况下）
        if
            event :? InputEventMouseMotion
            && Input.GetMouseMode() = Input.MouseModeEnum.Captured
        then
            let e = event :?> InputEventMouseMotion
            // 水平鼠标观察
            rot.Y <- rot.Y - e.Relative.X * MOUSE_SENSITIVITY
            // 垂直鼠标观察
            rot.X <- Mathf.Clamp(rot.X - e.Relative.Y * MOUSE_SENSITIVITY, -1.57f, 1.57f)
            let mutable trans = this.Transform
            trans.Basis <- Basis.FromEuler rot
            this.Transform <- trans

        if event.IsActionPressed "toggle_mouse_capture" then
            if Input.GetMouseMode() = Input.MouseModeEnum.Captured then
                Input.SetMouseMode Input.MouseModeEnum.Visible
            else
                Input.SetMouseMode Input.MouseModeEnum.Captured

    override this._Process(delta) =
        // 正则化 motion 来防止对角移动比直线移动快 `sqrt(2)` 倍
        let motion =
            Vector3(Input.GetAxis("MoveLeft", "MoveRight"), 0f, Input.GetAxis("MoveUp", "MoveDown"))
                .Normalized()

        velocity <- velocity + MOVE_SPEED * float32 delta * (this.Transform.Basis * motion)
        velocity <- velocity * 0.85f
        this.Position <- this.Position + velocity
