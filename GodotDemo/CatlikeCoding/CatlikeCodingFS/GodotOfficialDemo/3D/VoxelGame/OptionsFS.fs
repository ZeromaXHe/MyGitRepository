namespace CatlikeCodingFS.GodotOfficialDemo._3D.VoxelGame

open Godot

type OptionsFS() =
    inherit Control()

    member val PrevMenu: Control = null with get, set

    override this._Ready() =
        (this.GetNode<TextureButton> "CenterAnchor/HBoxContainer/Back")
            .add_Pressed (fun () ->
                this.PrevMenu.Visible <- true
                this.Visible <- false)
