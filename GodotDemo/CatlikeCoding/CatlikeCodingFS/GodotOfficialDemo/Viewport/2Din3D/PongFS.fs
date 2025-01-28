namespace CatlikeCodingFS.GodotOfficialDemo.Viewport._2Din3D

open Godot

type PongFS() =
    inherit Node2D()

    let PAD_SPEED = 150
    let INITIAL_BALL_SPEED = 80f

    let mutable ballSpeed = INITIAL_BALL_SPEED
    let mutable screenSize = Vector2(640f, 400f)
    // 默认球方向
    let mutable direction = Vector2.Left
    let mutable padSize = Vector2(8f, 32f)

    let mutable ball: Sprite2D = null
    let mutable leftPaddle: Sprite2D = null
    let mutable rightPaddle: Sprite2D = null

    override this._Ready() =
        ball <- this.GetNode<Sprite2D> "Ball"
        leftPaddle <- this.GetNode<Sprite2D> "LeftPaddle"
        rightPaddle <- this.GetNode<Sprite2D> "RightPaddle"
        screenSize <- this.GetViewportRect().Size
        padSize <- leftPaddle.GetTexture().GetSize()

    override this._Process(delta) =
        // 获得球位置和板矩形
        let mutable ballPos = ball.GetPosition()
        let leftRect = Rect2(leftPaddle.GetPosition() - padSize * 0.5f, padSize)
        let rightRect = Rect2(rightPaddle.GetPosition() - padSize * 0.5f, padSize)
        // 整合新球位置
        ballPos <- ballPos + direction * ballSpeed * float32 delta
        // 碰到顶部或底部时反转
        if
            (ballPos.Y < 0f && direction.Y < 0f)
            || (ballPos.Y > screenSize.Y && direction.Y > 0f)
        then
            direction.Y <- -direction.Y
        // 碰到板的时候：反转，改变方向并增加速度
        if
            (leftRect.HasPoint ballPos && direction.X < 0f)
            || (rightRect.HasPoint ballPos) && direction.X > 0f
        then
            direction.X <- -direction.X
            ballSpeed <- ballSpeed * 1.1f
            direction.Y <- GD.Randf() * 2f - 1f
            direction <- direction.Normalized()
        // 检查游戏结束
        if ballPos.X < 0f || ballPos.X > screenSize.X then
            ballPos <- screenSize * 0.5f
            ballSpeed <- INITIAL_BALL_SPEED
            direction <- Vector2.Left

        ball.SetPosition ballPos
        // 移动左侧板
        let mutable leftPos = leftPaddle.GetPosition()

        if leftPos.Y > 0f && Input.IsActionPressed "MoveUp" then
            leftPos.Y <- leftPos.Y - float32 PAD_SPEED * float32 delta

        if leftPos.Y < screenSize.Y && Input.IsActionPressed "MoveDown" then
            leftPos.Y <- leftPos.Y + float32 PAD_SPEED * float32 delta

        leftPaddle.SetPosition leftPos
        // 移动右侧板
        let mutable rightPos = rightPaddle.GetPosition()

        if rightPos.Y > 0f && Input.IsActionPressed "ui_up" then
            rightPos.Y <- rightPos.Y - float32 PAD_SPEED * float32 delta

        if rightPos.Y < screenSize.Y && Input.IsActionPressed "ui_down" then
            rightPos.Y <- rightPos.Y + float32 PAD_SPEED * float32 delta

        rightPaddle.SetPosition rightPos
