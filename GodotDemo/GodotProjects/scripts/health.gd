extends Node
class_name Health


signal changed(new_hp: float)


@export var max_health: float = 100.0
# 每秒回复多少血量
@export var refill_rate: float = 50.0

@onready var hp: float = max_health:
	set = set_health
@onready var refill_timer: Timer = $RefillTimer

var refill_enable = true


func _process(delta: float) -> void:
	if refill_enable and hp < max_health:
		hp = clamp(hp + refill_rate * delta, 0.0, max_health)


func set_health(new_hp):
	if new_hp < hp:
		refill_enable = false
		refill_timer.start(refill_timer.wait_time)
		
	hp = clamp(new_hp, 0, max_health)
	changed.emit(hp)


func _on_refill_timer_timeout() -> void:
	print("can refill hp now:", hp)
	refill_enable = true
