class_name GameTurnPanel
extends VBoxContainer


signal turn_button_clicked()


@onready var turn_text_button: Button = $TextPanel/TurnTextButton
@onready var turn_button: Button = $MainPanel/HBoxContainer/TurnButton


func _ready() -> void:
	show_end_turn()


func show_end_turn() -> void:
	turn_text_button.text = "下一回合"
	turn_button.icon = load("res://assets/icon_park/下一步_next.svg")


func show_unit_need_move() -> void:
	turn_text_button.text = "单位需要命令"
	turn_button.icon = load("res://assets/icon_park/注意_attention.svg")


func show_city_need_product() -> void:
	turn_text_button.text = "选择生产项目"
	turn_button.icon = load("res://assets/civ6_origin/core/webp_32x32/core_production.webp")


func show_tech_need_choose() -> void:
	turn_text_button.text = "选择科技"
	turn_button.icon = load("res://assets/civ6_origin/core/webp_32x32/core_science.webp")


func handle_turn_status_changed(status: HotSeatGame.TurnStatus) -> void:
	match status:
		HotSeatGame.TurnStatus.END_TURN:
			show_end_turn()
		HotSeatGame.TurnStatus.UNIT_NEED_MOVE:
			show_unit_need_move()
		HotSeatGame.TurnStatus.CITY_NEED_PRODUCT:
			show_city_need_product()
		HotSeatGame.TurnStatus.TECH_NEED_CHOOSE:
			show_tech_need_choose()


## 点击右下角的回合按钮
func _on_turn_button_pressed() -> void:
	turn_button_clicked.emit()


## 点击回合文字说明按钮
func _on_turn_text_button_pressed() -> void:
	turn_button_clicked.emit()
