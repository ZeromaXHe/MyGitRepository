namespace CatlikeCodingFS.GodotOfficialDemo.ComputeTexture

open Godot

type ComputeTextureFS() =
    inherit Node3D()

    // 注意：这里的代码仅仅添加一些我们效果的控制
    // 检查 `WaterPlaneFS` 来看真正实现
    let mutable y = 0f

    member this.WaterPlane = this.GetNode<WaterPlaneFS> "WaterPlane"

    override this._Ready() =
        let rainSlider = this.GetNode<HSlider> "Container/RainSize/HSlider"
        rainSlider.Value <- float this.WaterPlane.RainSize
        rainSlider.add_ValueChanged (fun value -> this.WaterPlane.RainSize <- float32 value)
        let mouseSlider = this.GetNode<HSlider> "Container/MouseSize/HSlider"
        mouseSlider.Value <- float this.WaterPlane.MouseSize
        mouseSlider.add_ValueChanged (fun value -> this.WaterPlane.MouseSize <- float32 value)

    override this._Process(delta) =
        if (this.GetNode<CheckBox> "Container/Rotate").ButtonPressed then
            y <- y + float32 delta
            this.WaterPlane.Basis <- Basis(Vector3.Up, y)
