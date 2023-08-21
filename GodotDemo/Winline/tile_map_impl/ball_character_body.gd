extends CharacterBody2D
class_name BallCharacterBody


signal ball_reached_target


@onready var img: Sprite2D = $Img
@onready var chosen_img: Sprite2D = $ChosenImg
@onready var navi_agent: NavigationAgent2D = $NavigationAgent2D

var speed = 300

func _ready() -> void:
	# 一开始不处于被选中的状态，不显示选中框
	chosen_img.visible = false
	
	# 导航相关的配置
	navi_agent.path_desired_distance = 5.0
	navi_agent.target_desired_distance = 10.0
	navi_agent.max_speed = speed


func _process(delta: float) -> void:
	if !navi_agent.is_navigation_finished():
		var next_position: Vector2 = navi_agent.get_next_path_position()
		velocity = global_position.direction_to(next_position) * speed
		move_and_slide()


func move_to(global_posi: Vector2):
	navi_agent.target_position = global_posi


func _on_navigation_agent_2d_navigation_finished() -> void:
	ball_reached_target.emit()
