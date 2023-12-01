class_name Player


const territory_border_scene: PackedScene = preload("res://scenes/game/territory_border_tile_map.tscn")

static var id_dict: Dictionary = {}

var id: int:
	set(id_new):
		if id > 0:
			id_dict.erase(id)
		id = id_new
		if id_new > 0:
			id_dict[id] = self
var territory_border: TerritoryBorderTileMap = territory_border_scene.instantiate()


static func add_player(player: PlayerDO) -> Player:
	PlayerService.add_player(player)
	var p := Player.new()
	p.initiate(player)
	return p


func initiate(player_do: PlayerDO) -> void:
	id = player_do.id
	(territory_border.material as ShaderMaterial).set_shader_parameter("to1", player_do.main_color)
	(territory_border.material as ShaderMaterial).set_shader_parameter("to2", player_do.second_color)

