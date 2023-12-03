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
	# 必须复制一份，不然颜色的修改会应用到所有 territory_border_scene 副本
	territory_border.material = territory_border.material.duplicate()
	(territory_border.material as ShaderMaterial).set_shader_parameter("to1", player_do.main_color)
	(territory_border.material as ShaderMaterial).set_shader_parameter("to2", player_do.second_color)

