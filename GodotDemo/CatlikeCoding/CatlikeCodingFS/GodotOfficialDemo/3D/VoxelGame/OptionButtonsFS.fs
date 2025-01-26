namespace CatlikeCodingFS.GodotOfficialDemo._3D.VoxelGame

open Godot

type OptionButtonsFS() =
    inherit GridContainer()

    member this.RenderDistanceLabel = this.GetNode<Label> "RenderDistanceLabel"
    member this.RenderDistanceSlider = this.GetNode<Slider> "RenderDistanceSlider"
    member this.FogCheckbox = this.GetNode<CheckBox> "FogCheckBox"

    override this._Ready() =
        this.RenderDistanceSlider.Value <- SettingsFS.Instance.RenderDistance
        this.RenderDistanceLabel.Text <- $"渲染距离: {SettingsFS.Instance.RenderDistance}"
        this.FogCheckbox.ButtonPressed <- SettingsFS.Instance.FogEnabled

        this.RenderDistanceSlider.add_ValueChanged (fun value ->
            SettingsFS.Instance.RenderDistance <- int value
            this.RenderDistanceLabel.Text <- $"渲染距离: {value}"
            SettingsFS.Instance.SaveSettings())

        this.FogCheckbox.add_Pressed (fun () ->
            SettingsFS.Instance.FogEnabled <- this.FogCheckbox.ButtonPressed
            SettingsFS.Instance.SaveSettings())
