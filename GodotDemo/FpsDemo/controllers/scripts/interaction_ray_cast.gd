extends RayCast3D

var interact_cast_result
var current_cast_result

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interact()


func _physics_process(delta: float) -> void:
	interact_cast()


func interact() -> void:
	if interact_cast_result and interact_cast_result.has_user_signal("interacted"):
		interact_cast_result.emit_signal("interacted")


func interact_cast() -> void:
	var current_cast_result = get_collider()
	if current_cast_result != interact_cast_result:
		if interact_cast_result and interact_cast_result.has_user_signal("unfocused"):
			interact_cast_result.emit_signal("unfocused")
		interact_cast_result = current_cast_result
		if interact_cast_result and interact_cast_result.has_user_signal("focused"):
			interact_cast_result.emit_signal("focused")
