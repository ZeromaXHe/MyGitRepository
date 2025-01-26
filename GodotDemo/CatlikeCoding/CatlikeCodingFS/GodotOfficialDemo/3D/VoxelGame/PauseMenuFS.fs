namespace CatlikeCodingFS.GodotOfficialDemo._3D.VoxelGame

open Godot

type PauseMenuFS() =
    inherit Control()

    let mutable crosshair: CenterContainer = null
    let mutable pause: VBoxContainer = null
    let mutable options = Unchecked.defaultof<OptionsFS>
    let mutable voxelWorld = Unchecked.defaultof<VoxelWorldFS>

    override this._Ready() =
        crosshair <- this.GetNode<CenterContainer> "Crosshair"
        pause <- this.GetNode<VBoxContainer> "Pause"
        options <- this.GetNode<OptionsFS> "Options"
        voxelWorld <- this.GetNode<VoxelWorldFS> "../VoxelWorld"

        let resume = this.GetNode<TextureButton> "Pause/ButtonHolder/MainButtons/Resume"

        resume.add_Pressed (fun () ->
            Input.SetMouseMode Input.MouseModeEnum.Captured
            crosshair.Visible <- true
            pause.Visible <- false)

        let optionsBtn =
            this.GetNode<TextureButton> "Pause/ButtonHolder/MainButtons/Options"

        optionsBtn.add_Pressed (fun () ->
            options.PrevMenu <- pause
            options.Visible <- true
            pause.Visible <- false)

        let mainMenu = this.GetNode<TextureButton> "Pause/ButtonHolder/MainButtons/MainMenu"

        mainMenu.add_Pressed (fun () ->
            voxelWorld.CleanUp()

            this.GetTree().ChangeSceneToPacked
            <| GD.Load<PackedScene> "res://Scenes/GodotOfficialDemo/3D/VoxelGame/Menu/Main/MainMenu.tscn"
            |> ignore)

        let exit = this.GetNode<TextureButton> "Pause/ButtonHolder/MainButtons/Exit"

        exit.add_Pressed (fun () ->
            voxelWorld.CleanUp()
            this.GetTree().Quit())

    override this._Process _ =
        if Input.IsActionJustPressed "pause" then
            pause.Visible <- crosshair.Visible
            crosshair.Visible <- not crosshair.Visible
            options.Visible <- false

            if crosshair.Visible then
                Input.SetMouseMode Input.MouseModeEnum.Captured
            else
                Input.SetMouseMode Input.MouseModeEnum.Visible
