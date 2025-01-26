namespace CatlikeCodingFS.GodotOfficialDemo._3D.VoxelGame

open Godot

type PlayerFS() =
    inherit CharacterBody3D()

    let EYE_HEIGHT_STAND = 1.6f
    let EYE_HEIGHT_CROUCH = 1.4f
    let MOVEMENT_SPEED_GROUND = 0.6f
    let MOVEMENT_SPEED_AIR = 0.11f
    let MOVEMENT_SPEED_CROUCH_MODIFIER = 0.5f
    let MOVEMENT_FRICTION_GROUND = 0.9f
    let MOVEMENT_FRICTION_AIR = 0.98f

    let mutable mouseMotion = Vector2.Zero
    let mutable selectedBlock = 6

    member this.Gravity =
        ProjectSettings.GetSetting("physics/3d/default_gravity").As<float32>()

    member this.Head = this.GetNode<Node3D> "Head"
    member this.RayCast = this.GetNode<RayCast3D> "Head/RayCast3D"

    member this.CameraAttributes =
        (this.GetNode<Camera3D> "Head/Camera3D").Attributes :?> CameraAttributesPractical

    member this.SelectedBlockTexture = this.GetNode<TextureRect> "SelectedBlock"
    member this.VoxelWorld = this.GetNode<VoxelWorldFS> "../VoxelWorld"
    member this.Crosshair = this.GetNode<CenterContainer> "../PauseMenu/Crosshair"

    override this._Ready() =
        Input.MouseMode <- Input.MouseModeEnum.Captured

    override this._Process _ =
        // 鼠标移动
        mouseMotion.Y <- Mathf.Clamp(mouseMotion.Y, -1112f, 1112f)
        let mutable thisTrans = this.Transform
        thisTrans.Basis <- Basis.FromEuler <| Vector3(0f, mouseMotion.X * -0.001f, 0f)
        this.Transform <- thisTrans
        let mutable headTrans = this.Head.Transform
        headTrans.Basis <- Basis.FromEuler <| Vector3(mouseMotion.Y * -0.001f, 0f, 0f)
        this.Head.Transform <- headTrans
        // 块选择
        let rayPosition = this.RayCast.GetCollisionPoint()
        let rayNormal = this.RayCast.GetCollisionNormal()

        if Input.IsActionJustPressed "pick_block" then
            // 块挑选
            let vec = (rayPosition - rayNormal / 2f).Floor()
            let blockGlobalPosition = Vector3I(int vec.X, int vec.Y, int vec.Z)
            selectedBlock <- this.VoxelWorld.GetBlockGlobalPosition blockGlobalPosition
        else
            // 前一个/下一个块的按键
            if Input.IsActionJustPressed "prev_block" then
                selectedBlock <- selectedBlock - 1

            if Input.IsActionJustPressed "next_block" then
                selectedBlock <- selectedBlock + 1

            selectedBlock <- Mathf.Wrap(selectedBlock, 1, 30)
        // 设置合理的纹理
        let uv = ChunkFS.CalculateBlockUvs selectedBlock
        (this.SelectedBlockTexture.Texture :?> AtlasTexture).Region <- Rect2(uv[0] * 512f, Vector2.One * 64f)
        // 破坏块 / 放置块
        if this.Crosshair.Visible && this.RayCast.IsColliding() then
            let breaking = Input.IsActionJustPressed "break"
            let placing = Input.IsActionJustPressed "place"
            // 两个按钮都被按下或者都不被按下，则直接停止
            if breaking <> placing then
                if breaking then
                    let vec3 = (rayPosition - rayNormal / 2f).Floor()
                    let blockGlobalPosition = Vector3I(int vec3.X, int vec3.Y, int vec3.Z)
                    this.VoxelWorld.SetBlockGlobalPosition blockGlobalPosition 0
                elif placing then
                    let vec3 = (rayPosition + rayNormal / 2f).Floor()
                    let blockGlobalPosition = Vector3I(int vec3.X, int vec3.Y, int vec3.Z)
                    this.VoxelWorld.SetBlockGlobalPosition blockGlobalPosition selectedBlock

    override this._PhysicsProcess delta =
        this.CameraAttributes.DofBlurFarEnabled <- SettingsFS.Instance.FogEnabled
        this.CameraAttributes.DofBlurFarDistance <- SettingsFS.Instance.FogDistance * 1.5f
        this.CameraAttributes.DofBlurFarTransition <- SettingsFS.Instance.FogDistance * 0.125f
        // 蹲下
        let crouching = Input.IsActionPressed "crouch"

        let trans = this.Head.Transform

        trans.Origin.Y <-
            Mathf.Lerp(
                this.Head.Transform.Origin.Y,
                (if crouching then EYE_HEIGHT_CROUCH else EYE_HEIGHT_STAND),
                16f * float32 delta
            )

        this.Head.Transform <- trans
        // 键盘移动
        let movementVec2 = Input.GetVector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")

        let mutable movement =
            this.Transform.Basis * Vector3(movementVec2.X, 0f, movementVec2.Y)

        if this.IsOnFloor() then
            movement <- movement * MOVEMENT_SPEED_GROUND
        else
            movement <- movement * MOVEMENT_SPEED_AIR

        if crouching then
            movement <- movement * MOVEMENT_SPEED_CROUCH_MODIFIER
        // 重力
        let mutable velocity = this.Velocity
        velocity.Y <- this.Velocity.Y - this.Gravity * float32 delta
        velocity <- velocity + Vector3(movement.X, 0f, movement.Z)
        // 应用水平摩擦力
        velocity.X <-
            velocity.X
            * if this.IsOnFloor() then
                  MOVEMENT_FRICTION_GROUND
              else
                  MOVEMENT_FRICTION_AIR

        velocity.Z <-
            velocity.Z
            * if this.IsOnFloor() then
                  MOVEMENT_FRICTION_GROUND
              else
                  MOVEMENT_FRICTION_AIR

        this.Velocity <- velocity
        this.MoveAndSlide() |> ignore
        // 跳跃，下一帧应用
        if this.IsOnFloor() && Input.IsActionPressed "Jump" then
            velocity.Y <- 7.5f
            this.Velocity <- velocity

    override this._Input(event) =
        if event :? InputEventMouseMotion then
            if Input.GetMouseMode() = Input.MouseModeEnum.Captured then
                mouseMotion <- mouseMotion + (event :?> InputEventMouseMotion).Relative
