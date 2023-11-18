class_name Player


const territory_border_scene: PackedScene = preload("res://scenes/game/territory_border_tile_map.tscn")

var territory_border: TerritoryBorderTileMap = territory_border_scene.instantiate()


func initiate(main_color: Color, second_color: Color) -> void:
	(territory_border.material as ShaderMaterial).set_shader_parameter("to1", main_color)
	(territory_border.material as ShaderMaterial).set_shader_parameter("to2", second_color)

