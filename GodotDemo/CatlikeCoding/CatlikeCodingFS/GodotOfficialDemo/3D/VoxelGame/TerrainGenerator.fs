namespace CatlikeCodingFS.GodotOfficialDemo._3D.VoxelGame

open Godot
open Godot.Collections

module TerrainGenerator =
    let RANDOM_BLOCK_PROBABILITY = 0.015f
    let empty () = new Dictionary()

    let randomBlocks chunkSize =
        let randomData = new Dictionary()

        for x in 0 .. chunkSize - 1 do
            for y in 0 .. chunkSize - 1 do
                for z in 0 .. chunkSize - 1 do
                    let vec = Vector3I(x, y, z)

                    if GD.Randf() < RANDOM_BLOCK_PROBABILITY then
                        randomData[vec] <- Variant.CreateFrom(GD.Randi() % 29u + 1u)

        randomData

    let flat chunkSize (chunkPosition: Vector3I) =
        let data = new Dictionary()

        if chunkPosition.Y <> -1 then
            data
        else
            for x in 0 .. chunkSize - 1 do
                for z in 0 .. chunkSize - 1 do
                    data[Vector3I(x, 0, z)] <- 3

            data

    let originGrass (chunkPosition: Vector3I) =
        if chunkPosition = Vector3I.Zero then
            let data = new Dictionary()
            data[Vector3I.Zero] <- 3
            data
        else
            empty ()
