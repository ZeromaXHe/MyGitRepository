extends AiState
class_name AiStateIdle


const state_enum: AiState.State = AiState.State.IDLE


func get_state_enum() -> AiState.State:
	return state_enum


func update_state(ai: AI) -> bool:
	if ai.actor.health.hp == 0:
		ai.set_ai_state(AI.AI_STATE_DEAD)
		return true
	# 初始化好就转为前进状态
	if ai.is_node_ready():
		ai.set_ai_state(AI.AI_STATE_ADVANCE)
		return true
	return false


func control_actor(ai: AI):
	pass
