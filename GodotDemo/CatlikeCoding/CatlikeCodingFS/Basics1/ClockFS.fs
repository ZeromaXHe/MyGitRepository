namespace CatlikeCodingFS.Basics1

open System
open Godot

[<AbstractClass>]
type ClockFS() =
    inherit Node3D()

    let _hoursToDegrees = -30f
    let _minutesToDegrees = -6f
    let _secondsToDegrees = -6f
    
    let mutable ready = false;

    abstract HoursPivot : Node3D with get, set
    abstract MinutesPivot : Node3D with get, set
    abstract SecondsPivot : Node3D with get, set

    member this.UpdatePivots() =
        let time = DateTime.Now.TimeOfDay
        this.HoursPivot.RotationDegrees <- Vector3(0f, 0f, _hoursToDegrees * float32 time.TotalHours)
        this.MinutesPivot.RotationDegrees <- Vector3(0f, 0f, _minutesToDegrees * float32 time.TotalMinutes)
        this.SecondsPivot.RotationDegrees <- Vector3(0f, 0f, _secondsToDegrees * float32 time.TotalSeconds)
        
    override this._Ready() =
        this.UpdatePivots()
        ready <- true
    
    override this._Process(delta) =
        if ready then
            this.UpdatePivots()
        