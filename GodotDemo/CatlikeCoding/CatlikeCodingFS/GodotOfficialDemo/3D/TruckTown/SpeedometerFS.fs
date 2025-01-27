namespace CatlikeCodingFS.GodotOfficialDemo._3D.TruckTown

open Godot

type SpeedUnit =
    | METERS_PER_SECOND = 0
    | KILOMETERS_PER_HOUR = 1
    | MILES_PER_HOUR = 2

[<AbstractClass>]
type SpeedometerFS() =
    inherit Button()

    let gradient = new Gradient()

    abstract SpeedUnit: SpeedUnit with get, set

    member val CarBody: VehicleBody3D = null with get, set

    override this._Ready() =
        // 起点和终点（偏移量 0.0 和 1.0）在创建时已在 Gradient 资源中定义。覆盖它们的颜色，并且只创建一个新点。
        gradient.SetColor(0, Color(0.7f, 0.9f, 1f))
        gradient.SetColor(1, Color(1f, 0.3f, 0.1f))
        gradient.AddPoint(0.2f, Color(1f, 1f, 1f))

        this.add_Pressed (fun () -> this.SpeedUnit <- enum<SpeedUnit> <| (int this.SpeedUnit + 1) % 3)

    override this._Process(delta) =
        let speed = this.CarBody.LinearVelocity.Length()

        if this.SpeedUnit = SpeedUnit.METERS_PER_SECOND then
            this.Text <- $"速度: %.1f{speed} m/s"
        elif this.SpeedUnit = SpeedUnit.KILOMETERS_PER_HOUR then
            this.Text <- $"速度: %.0f{speed * 3.6f} km/h"
        else // this.SpeedUnit = SpeedUnit.MILES_PER_HOUR
            this.Text <- $"速度: %.0f{speed * 2.23694f} mph"
        // 根据以 m/s 为单位的速度更改车速表颜色（无论单位如何）。
        this.AddThemeColorOverride(
            "font_color",
            gradient.Sample(Mathf.Remap(this.CarBody.LinearVelocity.Length(), 0f, 30f, 0f, 1f))
        )
