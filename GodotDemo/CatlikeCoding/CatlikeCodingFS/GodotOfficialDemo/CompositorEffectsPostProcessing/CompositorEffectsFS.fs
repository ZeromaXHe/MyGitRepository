namespace CatlikeCodingFS.GodotOfficialDemo.CompositorEffectsPostProcessing

open Godot

type CompositorEffectsFS() =
    inherit Node3D()

    member this.Compositor = this.GetNode<WorldEnvironment>("WorldEnvironment").Compositor

    member this.UpdateInfoText() =
        let g =
            if this.Compositor.CompositorEffects[0].Enabled then
                "Enabled"
            else
                "Disabled"

        let s =
            if this.Compositor.CompositorEffects[1].Enabled then
                "Enabled"
            else
                "Disabled"

        this.GetNode<Label>("Info").Text <-
            $"""Grayscale effect: {g}
Shader effect: {s}"""

    override this._Input(event) =
        if event.IsActionPressed "toggle_grayscale_effect" then
            this.Compositor.CompositorEffects[0].Enabled <- not this.Compositor.CompositorEffects[0].Enabled
            this.UpdateInfoText()

        if event.IsActionPressed "toggle_shader_effect" then
            this.Compositor.CompositorEffects[1].Enabled <- not this.Compositor.CompositorEffects[1].Enabled
            this.UpdateInfoText()
