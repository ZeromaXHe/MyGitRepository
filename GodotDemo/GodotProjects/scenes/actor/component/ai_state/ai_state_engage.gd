extends AiState
class_name AiStateEngage


const state_enum: AiState.State = AiState.State.ENGAGE


func get_state_enum() -> AiState.State:
	return state_enum


func update_state(ai: AI) -> bool:
	if ai.actor.health.hp == 0:
		ai.set_ai_state(AI.AI_STATE_DEAD)
		return true
	# 没有可交火的目标，则继续前进
	if not ai.exist_shootable_target():
		ai.set_ai_state(AI.AI_STATE_ADVANCE)
		return true
	return false


func control_actor(ai: AI):
	while ai.targets.size() > 0 and ai.targets[0].health.hp == 0:
		ai.targets.pop_front()
	if ai.targets.size() == 0:
		return
	for target in ai.targets:
		if not ai.actor.can_shoot(target):
			continue
		var angle_to_target = ai.actor.rotate_toward(target.global_position)
		# print("sin: ", sin(0.5 * (actor.rotation - angle_to_target)))
		
		# lerp_angle 貌似会让 actor.rotation 超过上限 PI 和下限 -PI
		# 所以这里用 sin(0.5x) 替代 x 来实现原教程类似的效果
		# 使得目标进入一定角度时开枪
		if abs(sin(0.5 * (ai.actor.rotation - angle_to_target))) < 0.08:
			ai.actor.weapon_manager.shoot()
		return
