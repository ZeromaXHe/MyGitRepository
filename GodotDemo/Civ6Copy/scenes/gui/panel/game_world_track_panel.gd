class_name GameWorldTrackPanel
extends VBoxContainer


signal tech_button_pressed


# 按钮组
@onready var sci_tree_button: Button = $MidTopLeftButtonPanel/ButtonHBox/SciTreeButton
@onready var sci_tree_small_hbox: HBoxContainer = $MidTopLeftButtonPanel/ButtonHBox/SciTreeSmallHBox
@onready var cul_tree_button: Button = $MidTopLeftButtonPanel/ButtonHBox/CulTreeButton
@onready var cul_tree_small_hbox: HBoxContainer = $MidTopLeftButtonPanel/ButtonHBox/CulTreeHBox
# 界面隐藏时的按钮相关信息
@onready var small_tech_progress_bar: ProgressBar = $MidTopLeftButtonPanel/ButtonHBox/SciTreeSmallHBox/TechProgressBar
@onready var small_tech_img: TextureRect = $MidTopLeftButtonPanel/ButtonHBox/SciTreeSmallHBox/TechImgPanel/TechImg
@onready var small_civic_progress_bar: ProgressBar = $MidTopLeftButtonPanel/ButtonHBox/CulTreeHBox/CivicProgressBar
@onready var small_civic_img: TextureRect = $MidTopLeftButtonPanel/ButtonHBox/CulTreeHBox/CivicImgPanel/CivicImg
# 世界追踪主界面
@onready var main_v_box: VBoxContainer = $MainVBox
@onready var track_panel_show_menu_btn: Button = $MainVBox/WorldTrackerTitlePanel/TrackPanelShowMenuBtn
@onready var sci_tree_panel: PanelContainer = $MainVBox/SciTreePanel
@onready var cul_tree_panel: PanelContainer = $MainVBox/CulTreePanel
@onready var unit_list_panel: PanelContainer = $MainVBox/UnitListPanel


func _ready() -> void:
	var popup_menu: PopupMenu = track_panel_show_menu_btn.get_popup()
	popup_menu.index_pressed.connect(handle_popup_menu_index_pressed)


func handle_popup_menu_index_pressed(index: int):
#	print("handle_popup_menu_index_pressed | index:", index)
	var popup_menu: PopupMenu = track_panel_show_menu_btn.get_popup()
	var check: bool = popup_menu.is_item_checked(index)
	var new_check: bool = not check
	popup_menu.set_item_checked(index, new_check)
	match index:
		0:
			sci_tree_panel.visible = new_check
			sci_tree_button.visible = new_check
			sci_tree_small_hbox.visible = check
		1:
			cul_tree_panel.visible = new_check
			cul_tree_button.visible = new_check
			cul_tree_small_hbox.visible = check
		2:
			unit_list_panel.visible = new_check


func _on_tech_button_pressed() -> void:
	tech_button_pressed.emit()


func _on_world_track_show_button_toggled(button_pressed: bool) -> void:
	main_v_box.visible = button_pressed
	if button_pressed:
		var popup_menu: PopupMenu = track_panel_show_menu_btn.get_popup()
		var sci_show: bool = popup_menu.is_item_checked(0)
		sci_tree_button.visible = sci_show
		sci_tree_small_hbox.visible = not sci_show
		var cul_show: bool = popup_menu.is_item_checked(1)
		cul_tree_button.visible = cul_show
		cul_tree_small_hbox.visible = not cul_show
	else:
		sci_tree_button.hide()
		sci_tree_small_hbox.show()
		cul_tree_button.hide()
		cul_tree_small_hbox.show()
