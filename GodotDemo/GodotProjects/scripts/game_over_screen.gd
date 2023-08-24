extends CanvasLayer
class_name GameOverScreen

@onready var title: Label = $PanelContainer/MarginContainer/Rows/Title
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var gameover_voice_anim_name: String = "game_win"

func _ready() -> void:
	get_tree().paused = true
	# 显示鼠标
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)


func set_title(win: bool):
	if win:
		title.text = "YOU WIN!"
		title.modulate = Color.GREEN
	else:
		title.text = "YOU LOSE!"
		title.modulate = Color.RED
	
	# 游戏结束语音
	if not win:
		gameover_voice_anim_name = "game_lose"


func play_gameover_voice():
	# 必须在 fade 动画后播放，不然会导致 fade 动画显示不出来
	anim_player.play(gameover_voice_anim_name)


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu_screen.tscn")
