extends Node3D


@onready var box_outline_mesh: MeshInstance3D = $OutlineMeshExample/Box/MeshInstance3D
@onready var csg_sphere_3d: CSGSphere3D = $NeedSmoothExample/CSGSphere3D
@onready var csg_box_3d: CSGBox3D = $NeedSmoothExample/CSGBox3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## 由于 CSGBox 和 CSGSphere 用的同一个材质，它们会同时高亮
func _on_sphere_static_body_mouse_entered() -> void:
	csg_sphere_3d.material.next_pass.set("grow", true)
	csg_sphere_3d.material.next_pass.set("grow_amount", 0.05)


func _on_sphere_static_body_mouse_exited() -> void:
	csg_sphere_3d.material.next_pass.set("grow", false)


func _on_box_static_body_mouse_entered() -> void:
	csg_box_3d.material.next_pass.set("grow", true)
	csg_box_3d.material.next_pass.set("grow_amount", 0.05)


func _on_box_static_body_mouse_exited() -> void:
	csg_box_3d.material.next_pass.set("grow", false)


func _on_box_2_static_body_mouse_entered() -> void:
	box_outline_mesh.show()


func _on_box_2_static_body_mouse_exited() -> void:
	box_outline_mesh.hide()
