extends AiState
class_name AiStatePatrol


const state_enum: AiState.State = AiState.State.PATROL


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
	return false


func control_actor(ai: AI):
	if ai.patrol_timer.is_stopped():
		# 防止重复启动巡逻计时器
		ai.patrol_timer.start()
	
	if ai.navigation_agent.is_navigation_finished():
		ai.actor.velocity = Vector2.ZERO
	else:
		AiState.navigation_move(ai)
