class_name GameTurnPanel
extends PanelContainer


signal turn_button_clicked()


@onready var turn_label: Label = $TurnVBox/TurnLabel
@onready var turn_button: Button = $TurnVBox/HBoxContainer/TurnButton


func _ready() -> void:
	show_end_turn()


func show_end_turn() -> void:
	turn_label.text = "结束回合"
	turn_button.icon = load("res://assets/icon_park/下一步_next.svg")


func show_unit_need_move() -> void:
	turn_label.text = "单位需要命令"
	turn_button.icon = load("res://assets/icon_park/注意_attention.svg")


func show_city_need_product() -> void:
	# TODO: 文案和图片暂时是我随便选的
	turn_label.text = "城市需要建造"
	turn_button.icon = load("res://assets/icon_park/注意_attention.svg")


func handle_turn_status_changed(status: HotSeatGame.TurnStatus) -> void:
	match status:
		HotSeatGame.TurnStatus.END_TURN:
			show_end_turn()
		HotSeatGame.TurnStatus.UNIT_NEED_MOVE:
			show_unit_need_move()
		HotSeatGame.TurnStatus.CITY_NEED_PRODUCT:
			show_city_need_product()


## 点击右下角的回合按钮
func _on_turn_button_pressed() -> void:
	turn_button_clicked.emit()
