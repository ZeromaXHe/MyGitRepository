namespace CatlikeCodingFS.GodotOfficialDemo.Viewport.ScreenCapture

open Godot

type ScreenCaptureFS() =
    inherit Control()

    member this.CapturedImage = this.GetNode<TextureRect> "CapturedImage"
    member this.CaptureButton = this.GetNode<Button> "CaptureButton"

    override this._Ready() =
        // 用于键盘/游戏手柄友好导航的焦点按钮。
        this.CaptureButton.GrabFocus()

        this.CaptureButton.add_Pressed (fun () ->
            GD.Print "按下按钮"
            // 获取截取的图片
            let img = this.GetViewport().GetTexture().GetImage()
            // 为它创建纹理
            let tex = ImageTexture.CreateFromImage img
            // 设置纹理到截取的图片节点
            this.CapturedImage.SetTexture tex
            // 用随机颜色给按钮着色，这样你就可以看到哪个按钮属于哪个捕捉。
            this.CaptureButton.Modulate <- Color.FromHsv(GD.Randf(), float32 <| GD.RandRange(0.2, 0.8), 1f))
