class_name LoadingScreen
extends Control


var scene_load_status: ResourceLoader.ThreadLoadStatus
var progress: Array = []

@onready var progress_bar: ProgressBar = $PanelContainer/CenterContainer/VBoxContainer/ProgressBar
@onready var label: Label = $PanelContainer/CenterContainer/VBoxContainer/Label


func _ready() -> void:
	GlobalScript.load_info = "加载中..."
	label.text = GlobalScript.load_info
	GlobalScript.load_info_changed.connect(handle_load_info_changed)
	progress_bar.value = 0
	ResourceLoader.load_threaded_request(GlobalScript.load_scene_path)


func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(GlobalScript.load_scene_path, progress)
	# progress[0] 会波动
	progress_bar.value = max(progress[0] * 100, progress_bar.value)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		GlobalScript.loaded_scene = ResourceLoader.load_threaded_get(GlobalScript.load_scene_path)
		if GlobalScript.jump_to_other_scene:
			get_tree().change_scene_to_file(GlobalScript.jump_scene_path)
		else:
			get_tree().change_scene_to_packed(GlobalScript.loaded_scene)


func handle_load_info_changed(load_info: String) -> void:
	# FIXME: 暂时没有效果
	label.text = load_info
