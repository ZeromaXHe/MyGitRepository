extends AiState
class_name AiStateAdvance


const state_enum: AiState.State = AiState.State.ADVANCE


func get_state_enum() -> AiState.State:
	return state_enum


func update_state(ai: AI) -> bool:
	if ai.actor.health.hp == 0:
		ai.set_ai_state(AI.AI_STATE_DEAD)
		return true
	# 存在可以射击的目标
	if ai.exist_shootable_target():
		ai.set_ai_state(AI.AI_STATE_ENGAGE)
		return true
	# 到达前往的基地
	if ai.navigation_agent.is_navigation_finished():
		ai.set_ai_state(AI.AI_STATE_PATROL)
		return true
	return false


func control_actor(ai: AI):
	AiState.navigation_move(ai)
