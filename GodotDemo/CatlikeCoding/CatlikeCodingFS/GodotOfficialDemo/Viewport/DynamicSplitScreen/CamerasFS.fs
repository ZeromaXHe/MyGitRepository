namespace CatlikeCodingFS.GodotOfficialDemo.Viewport.DynamicSplitScreen

open Godot

[<AbstractClass>]
type CamerasFS() =
    inherit Node3D()

    let mutable player1 = Unchecked.defaultof<PlayerFS>
    let mutable player2 = Unchecked.defaultof<PlayerFS>
    let mutable view: TextureRect = null
    let mutable viewport1: SubViewport = null
    let mutable viewport2: SubViewport = null
    let mutable camera1: Camera3D = null
    let mutable camera2: Camera3D = null

    let viewportBaseHeight =
        int <| ProjectSettings.GetSetting "display/window/size/viewport_height"

    // 处理两个玩家摄像头的运动以及与 SplitScreen 着色器，实现动态分屏效果
    //
    // 摄像机放置在连接两名玩家的片段上，如果玩家足够近则位于中间；或者如果他们不够近，则保持固定距离。
    // 在第一种情况下，两个摄像头位于同一位置，只有第一个视图用于整个屏幕，因此允许玩家在未分割的屏幕上玩。
    // 在第二种情况下，屏幕被一分为二，其中一条线垂直于连接两名玩家的线段。
    //
    // 自定义要点如下：
    // max_distance：视图开始分割时玩家之间的距离
    // split_line_thickness：分割线的厚度（像素）
    // split_line_color：分割线的颜色
    // adaptive_split_line_thickness：如果为 true，分割线厚度将根据玩家之间的距离发生变化
    // 如果为 false，则厚度将为常数，等于 split_line_thickness
    abstract MaxSeparation: float32 with get, set
    abstract SplitLineThickness: float32 with get, set
    abstract SplitLineColor: Color with get, set
    abstract AdaptiveSplitLineThickness: bool with get, set

    member this.OnSizeChanged() =
        let screenSize = this.GetViewport().GetVisibleRect().Size
        viewport1.Size <- Vector2I(int screenSize.X, int screenSize.Y)
        viewport2.Size <- Vector2I(int screenSize.X, int screenSize.Y)

        (view.Material :?> ShaderMaterial)
            .SetShaderParameter("viewport_size", screenSize)

    member this.GetPositionDifferenceInWorld() = player2.Position - player1.Position

    member this.GetHorizontalLength(vec: Vector3) = Vector2(vec.X, vec.Z).Length()

    // 如果分屏处于活动状态（当玩家彼此相距太远）返回 `true`，否则为 `false`。
    // 只有水平分量（x，z）用于距离计算。
    member this.IsSplitState() =
        let positionDifference = this.GetPositionDifferenceInWorld()
        let separationDistance = this.GetHorizontalLength positionDifference
        separationDistance > this.MaxSeparation

    member this.UpdateSplitscreen() =
        let screenSize = this.GetViewport().GetVisibleRect().Size
        let player1Position = camera1.UnprojectPosition player1.Position / screenSize
        let player2Position = camera2.UnprojectPosition player2.Position / screenSize
        let mutable thickness = 0f

        if this.AdaptiveSplitLineThickness then
            let positionDifference = this.GetPositionDifferenceInWorld()
            let distance = this.GetHorizontalLength positionDifference
            thickness <- Mathf.Lerp(0f, this.SplitLineThickness, (distance - this.MaxSeparation) / this.MaxSeparation)
            thickness <- Mathf.Clamp(thickness, 0f, this.SplitLineThickness)
        else
            thickness <- this.SplitLineThickness

        let viewMaterial = view.Material :?> ShaderMaterial
        viewMaterial.SetShaderParameter("split_active", this.IsSplitState())
        viewMaterial.SetShaderParameter("player1_position", player1Position)
        viewMaterial.SetShaderParameter("player2_position", player2Position)
        viewMaterial.SetShaderParameter("split_line_thickness", thickness)
        viewMaterial.SetShaderParameter("split_line_color", this.SplitLineColor)

    member this.MoveCameras() =
        let mutable positionDifference = this.GetPositionDifferenceInWorld()

        let distance =
            Mathf.Clamp(this.GetHorizontalLength positionDifference, 0f, this.MaxSeparation)

        positionDifference <- positionDifference.Normalized() * distance
        let mutable cam1Pos = camera1.Position
        cam1Pos.X <- player1.Position.X + positionDifference.X / 2f
        cam1Pos.Z <- player1.Position.Z + positionDifference.Z / 2f
        camera1.Position <- cam1Pos
        let mutable cam2Pos = camera2.Position
        cam2Pos.X <- player2.Position.X - positionDifference.X / 2f
        cam2Pos.Z <- player2.Position.Z - positionDifference.Z / 2f
        camera2.Position <- cam2Pos

    override this._Ready() =
        player1 <- this.GetNode<PlayerFS> "../Player1"
        player2 <- this.GetNode<PlayerFS> "../Player2"
        view <- this.GetNode<TextureRect> "View"
        viewport1 <- this.GetNode<SubViewport> "Viewport1"
        viewport2 <- this.GetNode<SubViewport> "Viewport2"
        camera1 <- viewport1.GetNode<Camera3D> "Camera1"
        camera2 <- viewport2.GetNode<Camera3D> "Camera2"

        this.OnSizeChanged()
        this.UpdateSplitscreen()

        this.GetViewport().add_SizeChanged (fun () -> this.OnSizeChanged())
        let viewMaterial = view.Material :?> ShaderMaterial
        viewMaterial.SetShaderParameter("viewport1", Variant.CreateFrom(viewport1.GetTexture()))
        viewMaterial.SetShaderParameter("viewport2", Variant.CreateFrom(viewport2.GetTexture()))

    override this._Process _ =
        this.MoveCameras()
        this.UpdateSplitscreen()
