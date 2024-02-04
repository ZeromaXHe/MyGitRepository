extends Control

static var path: String = "res://resource_loader/loaded_scene.tscn"

var loaded: bool = false

@onready var vbox: VBoxContainer = $CenterContainer/VBoxContainer
@onready var label: Label = $CenterContainer/VBoxContainer/Label
@onready var progress_bar: ProgressBar = $CenterContainer/VBoxContainer/ProgressBar


func _ready():
	ResourceLoader.load_threaded_request(path)


func _process(delta):
	if loaded:
		return
	var progress: Array = []
	var status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(path, progress)
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		vbox.add_child((ResourceLoader.load_threaded_get(path) as PackedScene).instantiate())
		label.text = "加载完成"
		progress_bar.value = 100
		loaded = true
	elif status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		progress_bar.value = progress[0]
	else:
		print("异常！" + str(status))
		loaded = true
