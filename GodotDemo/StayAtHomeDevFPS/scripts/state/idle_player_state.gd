class_name IdlePlayerState
extends State

func update(delta):
	if Global.player.velocity.length() > 0.0:
		transition.emit("WalkingPlayerState")
