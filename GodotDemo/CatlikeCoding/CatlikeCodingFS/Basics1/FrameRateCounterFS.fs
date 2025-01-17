namespace CatlikeCodingFS.Basics1

open System
open Godot


type DisplayMode =
    | FPS = 0
    | MS = 1

[<AbstractClass>]
type FrameRateCounterFS() =
    inherit Control()

    let mutable frames = 0
    let mutable duration = 0.
    let mutable bestDuration = Double.MaxValue
    let mutable worstDuration = 0.

    abstract Display: Label with get, set
    abstract DisplayMode: DisplayMode with get, set
    abstract SampleDuration: float with get, set

    override this._Process(delta) =
        frames <- frames + 1
        duration <- duration + delta

        if delta < bestDuration then
            bestDuration <- delta

        if delta > worstDuration then
            worstDuration <- delta

        if duration >= this.SampleDuration then
            if this.DisplayMode = DisplayMode.FPS then
                this.Display.Text <-
                    $"FPS\n%0.0f{1. / bestDuration}\n%0.0f{float frames / duration}\n%0.0f{1. / worstDuration}"
            else
                this.Display.Text <-
                    $"MS\n%.1f{1000. * bestDuration}\n%.1f{1000. * duration / float frames}\n%.1f{1000. * worstDuration}"

            frames <- 0
            duration <- 0.
            bestDuration <- Double.MaxValue
            worstDuration <- 0.
