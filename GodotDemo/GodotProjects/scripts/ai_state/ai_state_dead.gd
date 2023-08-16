extends AiState
class_name AiStateDead


const state_enum: AiState.State = AiState.State.DEAD


func get_state_enum() -> AiState.State:
	return state_enum


func update_state(ai: AI) -> bool:
	# Actor 复活了
	if ai.actor.health.hp > 0:
		ai.set_ai_state(AI.AI_STATE_ADVANCE)
		return true
	return false


func control_actor(ai: AI):
	AiState.navigation_move(ai)
