namespace CatlikeCodingFS.GodotOfficialDemo._3D.TruckTown

open Godot

type CarSelectFS() =
    inherit Control()

    let mutable town = Unchecked.defaultof<TownSceneFS>

    member this.OnBackPressed() =
        if GodotObject.IsInstanceValid town then
            // 当前在城镇中，返回主菜单
            town.QueueFree()
            this.Show()
            // 自动聚焦第一项，来使得 gamepad 可访问
            (Callable.From (this.GetNode<Button> "HBoxContainer/MiniVan").GrabFocus)
                .CallDeferred()
        else
            // 在主菜单，退出游戏
            this.GetTree().Quit()

    member this.LoadScene(carScene: PackedScene) =
        let car = carScene.Instantiate<Node3D>()
        car.Name <- "Car"

        town <-
            (GD.Load<PackedScene> "res://Scenes/GodotOfficialDemo/3D/TruckTown/Town/TownScene.tscn")
                .Instantiate<TownSceneFS>()

        if
            (this.GetNode<CheckBox> "PanelContainer/MarginContainer/HBoxContainer/Sunrise")
                .ButtonPressed
        then
            town.Mood <- Mood.SUNRISE
        elif
            (this.GetNode<CheckBox> "PanelContainer/MarginContainer/HBoxContainer/Day")
                .ButtonPressed
        then
            town.Mood <- Mood.DAY
        elif
            (this.GetNode<CheckBox> "PanelContainer/MarginContainer/HBoxContainer/Sunset")
                .ButtonPressed
        then
            town.Mood <- Mood.SUNSET
        elif
            (this.GetNode<CheckBox> "PanelContainer/MarginContainer/HBoxContainer/Night")
                .ButtonPressed
        then
            town.Mood <- Mood.NIGHT

        (town.GetNode<Marker3D> "InstancePos").AddChild car
        (town.GetNode<SpeedometerFS> "Speedometer").CarBody <- car.GetChild<VehicleBody3D> 0
        (town.GetNode<Button> "Back").add_Pressed (fun () -> this.OnBackPressed())

        this.GetParent().AddChild town
        this.Hide()

    override this._Ready() =
        let miniVan = this.GetNode<Button> "HBoxContainer/MiniVan"

        miniVan.add_Pressed (fun () ->
            this.LoadScene
            <| GD.Load<PackedScene> "res://Scenes/GodotOfficialDemo/3D/TruckTown/Vehicles/CarBase.tscn")

        let trailerTruck = this.GetNode<Button> "HBoxContainer/TrailerTruck"

        trailerTruck.add_Pressed (fun () ->
            this.LoadScene
            <| GD.Load<PackedScene> "res://Scenes/GodotOfficialDemo/3D/TruckTown/Vehicles/TrailerTruck.tscn")

        let towTruck = this.GetNode<Button> "HBoxContainer/TowTruck"

        towTruck.add_Pressed (fun () ->
            this.LoadScene
            <| GD.Load<PackedScene> "res://Scenes/GodotOfficialDemo/3D/TruckTown/Vehicles/TowTruck.tscn")
        // 自动聚焦第一项，来使得 gamepad 可访问
        (Callable.From miniVan.GrabFocus).CallDeferred()

    override this._Process _ =
        if Input.IsActionJustPressed "ui_cancel" then
            this.OnBackPressed()
