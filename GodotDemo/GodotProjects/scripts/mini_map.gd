extends Node2D
class_name MiniMap


@onready var player_icon: Sprite2D = $PlayerIcon

var actor_icon_map: Dictionary = {}
var base_icon_map: Dictionary = {}


func _process(delta: float) -> void:
	for actor in actor_icon_map:
		sync_actor_transform_to_icon(actor, actor_icon_map[actor])


func sync_actor_transform_to_icon(actor: Actor, icon: Sprite2D):
	icon.global_position = actor.global_position
	# 图像是向上的，但 Actor 图片向右，所以要多转 90 度
	icon.global_rotation_degrees = actor.global_rotation_degrees + 90


func create_actor_icon(actor: Actor):
	if actor.is_player():
		actor_icon_map[actor] = player_icon
	else:
		var icon = Sprite2D.new()
		icon.name = actor.name + "Icon"
		icon.texture = load("res://assets/simple_space/PNG/Retina/ship_E.png")
		if actor.team.side == Team.Side.PLAYER:
			icon.modulate = Color(Color.YELLOW_GREEN, 0.8)
		elif actor.team.side == Team.Side.ENEMY:
			icon.modulate = Color(Color.BLUE, 0.8)
		sync_actor_transform_to_icon(actor, icon)
		actor_icon_map[actor] = icon
		add_child(icon)


func delete_actor_icon(actor: Actor):
	if not actor.is_player():
		actor_icon_map[actor].queue_free()
		actor_icon_map.erase(actor)


func create_base_icon(base: CapturableBase):
	var icon = Sprite2D.new()
	icon.name = base.name + "Icon"
	icon.texture = load("res://assets/simple_space/PNG/Retina/meteor_detailedLarge.png")
	icon.modulate = get_base_icon_color(base)
	icon.global_position = base.global_position
	base.base_captured.connect(handle_base_captured)
	base_icon_map[base] = icon
	add_child(icon)


func handle_base_captured(base: CapturableBase):
	base_icon_map[base].modulate = get_base_icon_color(base)


func get_base_icon_color(base: CapturableBase) -> Color:
	if base.team.side == Team.Side.PLAYER:
		return Color(Color.DARK_GREEN, 0.8)
	elif base.team.side == Team.Side.ENEMY:
		return Color(Color.DARK_BLUE, 0.8)
	else:
		return Color(Color.GRAY, 0.8)
