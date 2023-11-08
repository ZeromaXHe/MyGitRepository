class_name GameTopPanel
extends PanelContainer


# 右上角回合数和年数显示
@onready var turn_and_year_label: Label = $TopRightHBox/TurnAndYearLabel
# 右上角时间的显示
@onready var time_label: Label = $TopRightHBox/TimeLabel


func _process(delta: float) -> void:
	update_time_label()


func update_time_label():
	var time_dict: Dictionary = Time.get_time_dict_from_system()
	var hour_val: int = time_dict["hour"]
	time_label.text = "%02d:%02d %s" % [hour_val if hour_val <= 12 else (hour_val - 12), \
			time_dict["minute"], " AM" if hour_val <= 12 else " PM"]


func handle_turn_changed(turn: int, year: int) -> void:
	var year_str: String = str(year) if year >= 0 else ("前" + str(-year))
	turn_and_year_label.text = "回合 %d/500\n公元%s年" % [turn, year_str]
