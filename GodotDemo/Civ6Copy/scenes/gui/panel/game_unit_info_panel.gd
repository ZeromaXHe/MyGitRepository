class_name GameUnitInfoPanel
extends VBoxContainer


signal city_button_pressed
signal skip_button_pressed
signal sleep_button_pressed


var showing_unit: Unit = null:
	set(unit):
		if showing_unit != null:
			showing_unit.unit_move_changed.disconnect(handle_unit_move_changed)
		showing_unit = unit
		if unit == null:
			hide()
		else:
			show_info()
			showing_unit.unit_move_changed.connect(handle_unit_move_changed)


@onready var unit_texture_rect: TextureRect = $MainPanel/UnitInfoVBox/DetailHBox/UnitTextureRect
@onready var name_button: Button = $MainPanel/UnitInfoVBox/NameButton
@onready var move_val_label: Label = $MainPanel/UnitInfoVBox/DetailHBox/DetailVBox/MovePanel/MoveHBox/MoveValLabel
@onready var melee_atk_panel: PanelContainer = $MainPanel/UnitInfoVBox/DetailHBox/DetailVBox/MeleeAtkPanel
# 上方按钮组
@onready var button_h_box: HBoxContainer = $ButtonPanel/ButtonHBox
@onready var city_button: Button = $ButtonPanel/ButtonHBox/CityButton
@onready var defend_button: Button = $ButtonPanel/ButtonHBox/DefendButton
@onready var skip_button: Button = $ButtonPanel/ButtonHBox/SkipButton
@onready var sleep_button: Button = $ButtonPanel/ButtonHBox/SleepButton
@onready var alert_button: Button = $ButtonPanel/ButtonHBox/AlertButton


func show_info() -> void:
	if showing_unit == null:
		printerr("GameUnitInfoPanel | show_info | weird, no showing unit, but show")
		return
	# 刷新内容
	var unit_do: UnitDO = UnitService.get_unit_do(showing_unit.id)
	name_button.text = UnitService.get_unit_name(unit_do.type)
	button_h_box.visible = unit_do.player_id == PlayerService.get_current_player_id() # 非本玩家单位，无法操作
	if button_h_box.visible:
		if unit_do.type == UnitTypeTable.Enum.SETTLER:
			city_button.show()
			defend_button.hide()
			skip_button.show()
			sleep_button.show()
			alert_button.hide()
			melee_atk_panel.hide()
		else:
			city_button.hide()
			defend_button.show()
			skip_button.show()
			sleep_button.hide()
			alert_button.show()
			melee_atk_panel.show()
	
	unit_texture_rect.texture = load(UnitService.get_unit_pic_200(unit_do.type))
	
	handle_unit_move_changed(unit_do.id, unit_do.move)
	# 显示出来
	show()


func handle_unit_move_changed(unit_id: int, move: int) -> void:
	if showing_unit == null or unit_id != showing_unit.id:
		return
	move_val_label.text = "%d/%d" % [move, UnitService.get_move_range(showing_unit.id)]


func handle_chosen_unit_changed(unit: Unit) -> void:
	showing_unit = unit


## 点击单位的建造城市按钮
func _on_city_button_pressed() -> void:
	city_button_pressed.emit()


## 点击单位的跳过按钮
func _on_skip_button_pressed() -> void:
	skip_button_pressed.emit()


## 点击单位的睡眠按钮
func _on_sleep_button_pressed() -> void:
	sleep_button_pressed.emit()


## 点击单位的驻扎按钮
func _on_defend_button_pressed() -> void:
	# TODO: 暂时先按睡眠处理
	sleep_button_pressed.emit()


# 点击单位的警戒按钮
func _on_alert_button_pressed() -> void:
	# TODO: 暂时先按跳过处理
	skip_button_pressed.emit()
