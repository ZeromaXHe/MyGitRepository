extends Node3D


func set_length(length: float):
	$BulletWakeVolume.size.y = length
	$Debug.mesh.height = length


func _ready() -> void:
	$BulletWakeVolume.tree_exited.connect(queue_free)
