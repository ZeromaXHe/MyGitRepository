extends Node2D


const player = preload("res://godotsteam_xiaoye/player.tscn")

@onready var position_array = [$P1, $P2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index = 0
	for member in GlobalSteam.lobby_members:
		var ins = player.instantiate()
		ins.name = str(member['id'])
		ins.is_controlled = GlobalSteam.steam_id == member['id']
		ins.global_position = position_array[index].global_position
		add_child(ins)
		index += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
