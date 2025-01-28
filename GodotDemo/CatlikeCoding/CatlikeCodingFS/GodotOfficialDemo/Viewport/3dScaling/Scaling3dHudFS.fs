namespace CatlikeCodingFS.GodotOfficialDemo.Viewport._3dScaling

open Godot

type Scaling3dHudFS() =
    inherit Control()
    // 三维视口的收缩因子。例如 1 是全分辨率，
    // 2 是半分辨率，4 是四分之一分辨率。较低的值看起来更清晰，但渲染速度较慢。
    let mutable scaleFactor = 1
    let mutable filterMode = Viewport.Scaling3DModeEnum.Bilinear

    member this.Viewport = this.GetTree().Root
    member this.ScaleLabel = this.GetNode<Label> "VBoxContainer/Scale"
    member this.FilterLabel = this.GetNode<Label> "VBoxContainer/Filter"

    override this._Ready() =
        this.Viewport.Scaling3DMode <- filterMode

    override this._UnhandledInput(event) =
        if event.IsActionPressed "Jump" then
            scaleFactor <- Mathf.Wrap(scaleFactor + 1, 1, 5)
            this.Viewport.Scaling3DScale <- 1f / float32 scaleFactor
            this.ScaleLabel.Text <- $"缩放: %3.0f{100f / float32 scaleFactor}"

        if event.IsActionPressed "ui_text_newline" then
            let fmi =
                Mathf.Wrap(
                    int filterMode + 1,
                    int Viewport.Scaling3DModeEnum.Bilinear,
                    int Viewport.Scaling3DModeEnum.Max
                )

            filterMode <- LanguagePrimitives.EnumOfValue <| int64 fmi // enum<Viewport.Scaling3DModeEnum> 用不了，因为枚举值是 long
            this.Viewport.Scaling3DMode <- filterMode
            // GD.Print(nameof Viewport)
            // this.FilterLabel.Text <-
            //     ClassDB.ClassGetEnumConstants(nameof Viewport, Viewport.PropertyName.Scaling3DMode)[int filterMode]
            let text =
                match filterMode with
                | Viewport.Scaling3DModeEnum.Bilinear -> "双线性"
                | Viewport.Scaling3DModeEnum.Fsr -> "FSR"
                | Viewport.Scaling3DModeEnum.Fsr2 -> "FSR 2"
                | _ -> "未知"

            this.FilterLabel.Text <- $"缩放 3D 模式: {text}"
