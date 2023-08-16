extends Node
class_name AiState

enum State {
	IDLE,
	PATROL,
	ENGAGE,
	ADVANCE,
	DEAD,
}


func get_state_enum() -> AiState.State:
	return -1


func update_state(ai: AI) -> bool:
	printerr("update_state() should be overriden")
	return false


func control_actor(ai: AI):
	printerr("control_actor() should be overriden")


static func navigation_move(ai: AI):
	var next_position: Vector2 = ai.navigation_agent.get_next_path_position()
	ai.actor.rotate_toward(next_position)
	if ai.navigation_agent.avoidance_enabled:
		ai.navigation_agent.set_velocity(ai.actor.velocity_toward(next_position))
	else:
		ai.actor.velocity_toward(next_position)
		# 4.1 中的 move_and_slide 不需要传参了，直接根据 velocity 移动
		ai.actor.move_and_slide()
