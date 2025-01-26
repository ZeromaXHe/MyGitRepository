namespace CatlikeCodingFS.GodotOfficialDemo._3D.VoxelGame

open Godot

type MainMenuFS() =
    inherit Control()

    member this.Title = this.GetNode<VBoxContainer> "TitleScreen"
    member this.Start = this.GetNode<HBoxContainer> "StartGame"
    member this.Options = this.GetNode<OptionsFS> "Options"

    override this._Ready() =
        let startButton =
            this.GetNode<TextureButton> "TitleScreen/ButtonHolder/MainButtons/Start"

        startButton.add_Pressed (fun () ->
            this.Start.Visible <- true
            this.Title.Visible <- false)

        let optionsButton =
            this.GetNode<TextureButton> "TitleScreen/ButtonHolder/MainButtons/Options"

        optionsButton.add_Pressed (fun () ->
            this.Options.PrevMenu <- this.Title
            this.Options.Visible <- true
            this.Title.Visible <- false)

        let exitButton =
            this.GetNode<TextureButton> "TitleScreen/ButtonHolder/MainButtons/Exit"

        exitButton.add_Pressed (fun () -> this.GetTree().Quit())

        let randomBlocksButton =
            this.GetNode<TextureButton> "StartGame/StartButtons/RandomBlocks"

        randomBlocksButton.add_Pressed (fun () ->
            SettingsFS.Instance.WorldType <- 0

            this
                .GetTree()
                .ChangeSceneToPacked(
                    GD.Load<PackedScene> "res://Scenes/GodotOfficialDemo/3D/VoxelGame/World/World.tscn"
                )
            |> ignore)

        let flatGrassButton = this.GetNode<TextureButton> "StartGame/StartButtons/FlatGrass"

        flatGrassButton.add_Pressed (fun () ->
            SettingsFS.Instance.WorldType <- 1

            this.GetTree().ChangeSceneToPacked
            <| GD.Load<PackedScene> "res://Scenes/GodotOfficialDemo/3D/VoxelGame/World/World.tscn"
            |> ignore)

        let backToTitleButton =
            this.GetNode<TextureButton> "StartGame/StartButtons/BackToTitle"

        backToTitleButton.add_Pressed (fun () ->
            this.Title.Visible <- true
            this.Start.Visible <- false)
