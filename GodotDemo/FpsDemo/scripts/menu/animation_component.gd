class_name AnimationComponent
extends Node

@export_group("选项")
@export var from_center: bool = true
@export var parallel_animations: bool = true
@export var properties: Array = [
	"scale",
	"position",
	"rotation",
	"size",
	"self_modulate"
]

@export_group("悬浮设置")
@export var hover_time: float = 0.1
@export var hover_delay: float = 0.0
@export var hover_transition: Tween.TransitionType
@export var hover_easing: Tween.EaseType
@export var hover_position: Vector2
@export var hover_scale := Vector2.ONE
@export var hover_rotation: float
@export var hover_size: Vector2
@export var hover_modulate := Color.WHITE

var target: Control
var default_scale: Vector2
var hover_values: Dictionary
var default_values: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_parent()
	setup.call_deferred()


func connect_signals() -> void:
	target.mouse_entered.connect(add_tween.bind(
		hover_values, parallel_animations, hover_time, hover_delay, hover_transition, hover_easing))
	target.mouse_exited.connect(add_tween.bind(
		default_values, parallel_animations, hover_time, hover_delay, hover_transition, hover_easing))


func setup() -> void:
	if from_center:
		target.pivot_offset = target.size / 2
	default_scale = target.scale
	default_values = {
		"scale": target.scale,
		"position": target.position,
		"rotation": target.rotation,
		"size": target.size,
		"self_modulate": target.modulate,
	}
	hover_values = {
		"scale": hover_scale,
		"position": target.position + hover_position,
		"rotation": target.rotation + deg_to_rad(hover_rotation),
		"size": target.size + hover_size,
		"self_modulate": hover_modulate,
	}
	connect_signals()


func add_tween(values: Dictionary, parallel: bool, seconds: float, delay: float,
		transition: Tween.TransitionType, easing: Tween.EaseType) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel(parallel)
	tween.tween_interval(delay) # 明明就是一行的事情，被 StayAtHomeDev 又折腾一集……
	#tween.pause()
	for property: String in properties:
		tween.tween_property(target, property, values[property], seconds) \
			.set_trans(transition) \
			.set_ease(easing)
	#await get_tree().create_timer(delay).timeout
	#tween.play()
