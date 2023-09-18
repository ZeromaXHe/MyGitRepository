class_name MapEditorGUI
extends CanvasLayer


enum TabStatus {
	PLACE,
	GRID,
}


@onready var info_label: Label = $MarginContainer/RightTopPanelContainer/RtVBoxContainer/TitleVBoxContainer/InfoLabel
@onready var rt_tab: TabContainer = $MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer


func get_rt_tab_status() -> TabStatus:
	if rt_tab.current_tab == 0:
		return TabStatus.PLACE
	else:
		return TabStatus.GRID


func set_info_label_text(text: String) -> void:
	info_label.text = text
