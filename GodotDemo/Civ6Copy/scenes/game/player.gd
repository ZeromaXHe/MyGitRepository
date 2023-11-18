class_name Player


const territory_border_scene: PackedScene = preload("res://scenes/game/territory_border_tile_map.tscn")

var id: int
var territory_border: TerritoryBorderTileMap = territory_border_scene.instantiate()


func initiate(player_do: PlayerDO) -> void:
	id = player_do.id
	(territory_border.material as ShaderMaterial).set_shader_parameter("to1", player_do.main_color)
	(territory_border.material as ShaderMaterial).set_shader_parameter("to2", player_do.second_color)

