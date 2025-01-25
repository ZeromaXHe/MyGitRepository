namespace CatlikeCodingFS.GodotOfficialDemo._3D.Waypoints

open Godot
open Microsoft.FSharp.Core

[<AbstractClass>]
type WaypointFS() =
    inherit Control()

    // 一些边距来保持标记远离屏幕角落
    let MARGIN = 8f
    let mutable camera: Camera3D = null

    // 路点文本
    abstract Text: string with get, set
    abstract Sticky: bool with get, set

    member this.Parent = this.GetParent() :?> Node3D
    member this.Label = this.GetNode<Label> "Label"
    member this.Marker = this.GetNode<TextureRect> "Marker"

    override this._Ready() =
        this.Text <- this.Text

        if this.Parent = null then
            GD.PushError "路点父节点必须继承 Node3D"

        camera <- this.GetViewport().GetCamera3D()

    override this._Process(delta) =
        if not camera.Current then
            // 如果我们拥有的摄像头不是当前的，则获取当前摄像头
            camera <- this.GetViewport().GetCamera3D()

        let parentPosition = this.Parent.GlobalTransform.Origin
        let cameraTransform = camera.GlobalTransform
        let cameraPosition = cameraTransform.Origin
        // 我们将使用 "camera.IsPositionBehind(parentPosition)"，除非它也计算了近裁剪平面，这是我们不希望的
        let isBehind = cameraTransform.Basis.Z.Dot(parentPosition - cameraPosition) > 0f
        // 当摄像头靠近时渐隐路点
        let distance = cameraPosition.DistanceTo parentPosition
        let mutable modulate = this.Modulate
        modulate.A <- Mathf.Clamp(Mathf.Remap(distance, 0f, 2f, 0f, 1f), 0f, 1f)
        this.Modulate <- modulate

        let mutable unprojectedPosition = camera.UnprojectPosition parentPosition
        // `GetSizeOverride()` 将仅在拉伸模式为 `2d` 时返回一个可用尺寸
        // 否则，直接使用 viewport 尺寸
        let viewportBaseSize =
            if (this.GetViewport() :?> Window).ContentScaleSize <> Vector2I.Zero then
                (this.GetViewport() :?> Window).ContentScaleSize
            else
                (this.GetViewport() :?> Window).Size

        if not this.Sticky then
            // 对于不 sticky 的路点，如果路店在屏幕外，我们不需要 clamp 和计算位置
            this.Position <- unprojectedPosition
            this.Visible <- not isBehind
        else
            // 我们需要区别处理轴
            // 对于屏幕 X 轴，投射位置对我们有用，但如果它在背后，我们需要强制它在边上
            if isBehind then
                if unprojectedPosition.X < float32 viewportBaseSize.X / 2f then
                    unprojectedPosition.X <- float32 viewportBaseSize.X - MARGIN
                else
                    unprojectedPosition.X <- MARGIN
            // 对于屏幕 Y 轴，投射位置对我们没用，因为我们不想指示用户他们需要向上下看来看他们后面的东西。
            // 作为替代，我们使用 X 轴欧拉角的差（上/下旋转）和摄像头 FOV 比例来近似。
            // 这将轻微偏离理论上“理想的”位置
            if
                isBehind
                || unprojectedPosition.X < MARGIN
                || unprojectedPosition.X > float32 viewportBaseSize.X - MARGIN
            then
                let look = cameraTransform.LookingAt(parentPosition, Vector3.Up)

                let diff =
                    Mathf.AngleDifference(look.Basis.GetEuler().X, cameraTransform.Basis.GetEuler().X)

                unprojectedPosition.Y <- float32 viewportBaseSize.Y * (0.5f + (diff / Mathf.DegToRad camera.Fov))

            this.Position <-
                Vector2(
                    Mathf.Clamp(unprojectedPosition.X, MARGIN, float32 viewportBaseSize.X - MARGIN),
                    Mathf.Clamp(unprojectedPosition.Y, MARGIN, float32 viewportBaseSize.Y - MARGIN)
                )

            this.Label.Visible <- true
            this.Rotation <- 0f
            // 当路点被展示在屏幕角上时，用来展示对角线箭头
            let mutable overflow = 0

            if this.Position.X <= MARGIN then
                // 左溢出
                overflow <- int <| -Mathf.Tau / 8f
                this.Label.Visible <- false
                this.Rotation <- Mathf.Tau / 4f
            elif this.Position.X >= float32 viewportBaseSize.X - MARGIN then
                // 右溢出
                overflow <- int <| Mathf.Tau / 8f
                this.Label.Visible <- false
                this.Rotation <- Mathf.Tau * 3f / 4f

            if this.Position.Y <= MARGIN then
                // 上溢出
                this.Label.Visible <- false
                this.Rotation <- Mathf.Tau / 2f + float32 overflow
            elif this.Position.Y >= float32 viewportBaseSize.Y - MARGIN then
                // 下溢出
                this.Label.Visible <- false
                this.Rotation <- -float32 overflow
