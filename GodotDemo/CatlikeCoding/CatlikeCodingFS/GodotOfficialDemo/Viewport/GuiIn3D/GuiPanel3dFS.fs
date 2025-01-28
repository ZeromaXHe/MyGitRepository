namespace CatlikeCodingFS.GodotOfficialDemo.Viewport.GuiIn3D

open Godot

type GuiPanel3dFS() =
    inherit Node3D()

    // 用于检查鼠标是否在 Area3D 内。
    let mutable isMouseInside = false
    // 最后处理的输入触摸/鼠标事件。用于计算相对运动。
    let mutable lastEventPos2D = Vector2.Zero
    // 引擎启动后最后一个事件的时间（秒）。
    let mutable lastEventTime = -1f

    member this.NodeViewport = this.GetNode<SubViewport> "SubViewport"
    member this.NodeQuad = this.GetNode<MeshInstance3D> "Quad"
    member this.NodeArea = this.GetNode<Area3D> "Quad/Area3D"

    member this.RotateAreaToBillboard() =
        let billboardMode =
            (this.NodeQuad.GetSurfaceOverrideMaterial 0 :?> BaseMaterial3D).BillboardMode
        // 如果启用，请尝试将该区域与材质的广告牌设置相匹配。
        if billboardMode > BaseMaterial3D.BillboardModeEnum.Disabled then
            // 获取摄像头
            let camera = this.GetViewport().GetCamera3D()
            // 看向与相机相同的方向。
            let mutable look =
                camera.ToGlobal(Vector3(0f, 0f, -100f)) - camera.GlobalTransform.Origin

            look <- this.NodeArea.Position + look
            // Y-Billboard：锁定Y轴旋转，但如果相机倾斜，则效果不佳。
            if billboardMode = BaseMaterial3D.BillboardModeEnum.FixedY then
                look <- Vector3(look.X, 0f, look.Z)

            this.NodeArea.LookAt(look, Vector3.Up)
            // 沿Z轴旋转以补偿相机倾斜。
            this.NodeArea.RotateObjectLocal(Vector3.Back, camera.Rotation.Z)

    member this.MouseInputEvent
        (node: Node)
        (event: InputEvent)
        (eventPosition: Vector3)
        (normal: Vector3)
        (shapeIdx: int64)
        =
        let camera = node :?> Camera3D
        // 获取网格大小以检测边缘并进行转换。此代码仅支持 PlaneMesh 和 QuadMesh。
        let quadMeshSize =
            if this.NodeQuad.Mesh :? PlaneMesh then
                (this.NodeQuad.Mesh :?> PlaneMesh).Size
            else
                (this.NodeQuad.Mesh :?> QuadMesh).Size
        // 世界坐标空间中 Area3D 中的事件位置。
        let mutable eventPos3D = eventPosition
        // 引擎启动后的当前时间（秒）。
        let now = float32 (Time.GetTicksMsec()) / 1000f
        // 将位置转换为相对于Area3D节点的坐标空间。
        // 注意：`affineinverse（）`解释了Area3D节点在场景中的缩放、旋转和位置！
        eventPos3D <- this.NodeQuad.GlobalTransform.AffineInverse() * eventPos3D
        // TODO：适应公告板板模式或完全避免。
        let mutable eventPos2D = Vector2.Zero

        if isMouseInside then
            // 将相对事件位置从 3D 转换为 2D。
            eventPos2D <- Vector2(eventPos3D.X, -eventPos3D.Y)
            // 现在，事件位置的范围如下：（-quad_size/2）->（quad_size/2）
            // 我们需要将其转换为以下范围：-0.5 -> 0.5
            eventPos2D.X <- eventPos2D.X / quadMeshSize.X
            eventPos2D.Y <- eventPos2D.Y / quadMeshSize.Y
            // 然后我们需要将其转换为以下范围：0 -> 1
            eventPos2D.X <- eventPos2D.X + 0.5f
            eventPos2D.Y <- eventPos2D.Y + 0.5f
            // 最后，我们将位置转换为以下范围：0->viewport.size
            // 我们需要进行这些转换，以便事件的位置在视口的坐标系中。
            eventPos2D.X <- eventPos2D.X * float32 this.NodeViewport.Size.X
            eventPos2D.Y <- eventPos2D.Y * float32 this.NodeViewport.Size.Y
        elif lastEventPos2D <> Vector2.Zero then
            // 退回到最后一个已知的事件位置。
            eventPos2D <- lastEventPos2D

        // 设置事件的位置和全局位置。
        event.Set(InputEventMouse.PropertyName.Position, eventPos2D)

        if event :? InputEventMouse then
            (event :?> InputEventMouse).GlobalPosition <- eventPos2D
        // 计算相对事件距离
        if event :? InputEventMouseMotion || event :? InputEventScreenDrag then
            // 如果没有存储的先前位置，那么我们将假设没有相对运动。
            if lastEventPos2D = Vector2.Zero then
                event.Set(InputEventMouseMotion.PropertyName.Relative, Vector2.Zero)
            else
                // 如果有一个存储的先前位置，那么我们将通过从新位置减去之前的位置计算。这将为我们提供事件与 prev_pos 之间的距离。
                let relative = eventPos2D - lastEventPos2D
                event.Set(InputEventMouseMotion.PropertyName.Relative, relative)

                event.Set(
                    InputEventMouseMotion.PropertyName.Velocity,
                    Variant.CreateFrom(relative / (now - lastEventTime))
                )
        // 用我们刚刚计算的位置更新 last_event_pos2D。
        lastEventPos2D <- eventPos2D
        // 将 last_event_time 更新为当前时间。
        lastEventTime <- now
        // 最后，将处理后的输入事件发送到视口。
        this.NodeViewport.PushInput event

    override this._Ready() =
        this.NodeArea.add_MouseEntered (fun () ->
            isMouseInside <- true
            // 通知视口鼠标现在正在悬停。
            this.NodeViewport.Notification <| int Node.NotificationVpMouseEnter)

        this.NodeArea.add_MouseExited (fun () ->
            // 通知视口鼠标不再悬停。
            this.NodeViewport.Notification <| int Node.NotificationVpMouseExit
            isMouseInside <- false)

        this.NodeArea.add_InputEvent this.MouseInputEvent
        // 如果材料未设置为使用广告牌设置，则避免运行特定于广告牌的代码
        if
            (this.NodeQuad.GetSurfaceOverrideMaterial 0 :?> BaseMaterial3D).BillboardMode = BaseMaterial3D.BillboardModeEnum.Disabled
        then
            this.SetProcess false

    override this._Process(delta) =
        // #注意：如果您不打算使用广告牌设置，请删除此功能。
        this.RotateAreaToBillboard()

    override this._UnhandledInput(event) =
        // 检查事件是否为非鼠标/非触摸事件
        if
            event :? InputEventMouseButton
            || event :? InputEventMouseMotion
            || event :? InputEventScreenDrag
            || event :? InputEventScreenTouch
        then
            ()
        else
            this.NodeViewport.PushInput event
