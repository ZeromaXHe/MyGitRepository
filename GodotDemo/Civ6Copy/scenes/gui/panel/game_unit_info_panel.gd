class_name GameUnitInfoPanel
extends VBoxContainer


signal city_button_pressed
signal skip_button_pressed
signal sleep_button_pressed


var showing_unit: Unit = null:
	set(unit):
		showing_unit = unit
		if unit == null:
			hide()
		else:
			show_info()


@onready var unit_texture_rect: TextureRect = $MainPanel/UnitInfoVBox/DetailHBox/UnitTextureRect
@onready var name_button: Button = $MainPanel/UnitInfoVBox/NameButton
@onready var move_val_label: Label = $MainPanel/UnitInfoVBox/DetailHBox/DetailVBox/MovePanel/MoveHBox/MoveValLabel
@onready var melee_atk_panel: PanelContainer = $MainPanel/UnitInfoVBox/DetailHBox/DetailVBox/MeleeAtkPanel
# 上方按钮组
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
	var unit_do: UnitDO = UnitController.get_unit_do(showing_unit.id)
	name_button.text = UnitController.get_unit_name(unit_do.type)
	if unit_do.type == UnitTypeTable.Type.SETTLER:
		city_button.show()
		defend_button.hide()
		skip_button.show()
		sleep_button.show()
		alert_button.hide()
		melee_atk_panel.hide()
	else:
		city_button.hide()
		defend_button.show()
		skip_button.hide()
		sleep_button.hide()
		alert_button.show()
		melee_atk_panel.show()
	
	unit_texture_rect.texture = load(UnitController.get_unit_pic_200(unit_do.type))
	
	handle_unit_move_changed(unit_do.id, unit_do.move)
	# 绑定信号，方便后续更新信息
	connect_showing_unit_signals()
	# 显示出来
	show()


func connect_showing_unit_signals() -> void:
	ViewSignalsEmitter.get_instance().unit_move_changed.connect(handle_unit_move_changed)


func handle_unit_move_changed(unit_id: int, move: int) -> void:
	if showing_unit == null or unit_id != showing_unit.id:
		return
	move_val_label.text = "%d/%d" % [move, UnitController.get_move_range(showing_unit.id)]


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
