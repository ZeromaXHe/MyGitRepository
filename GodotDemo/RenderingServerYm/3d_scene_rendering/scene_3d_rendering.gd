extends Node3D

@export var mesh: Mesh
@export var environment: Environment

var instance_mesh: RID
var camera: RID
var light: RID
var light_instance: RID
var trans := Transform3D.IDENTITY


func _ready() -> void:
	var viewport: RID = get_viewport().get_viewport_rid()
	var scenario: RID = get_world_3d().scenario
	RenderingServer.scenario_set_environment(scenario, environment.get_rid())
	instance_mesh = RenderingServer.instance_create()
	RenderingServer.instance_set_base(instance_mesh, mesh.get_rid())
	RenderingServer.instance_set_scenario(instance_mesh, scenario)
	camera = RenderingServer.camera_create()
	RenderingServer.viewport_attach_camera(viewport, camera)
	var camera_transform := Transform3D(Basis.IDENTITY, Vector3(0, 0, 3))
	RenderingServer.camera_set_transform(camera, camera_transform)
	RenderingServer.camera_set_perspective(camera, 75.0, 0.05, 4000.0)
	light = RenderingServer.directional_light_create()
	light_instance = RenderingServer.instance_create()
	RenderingServer.instance_set_base(light_instance, light)
	var light_transform := Transform3D(
		Basis.from_euler(Vector3(deg_to_rad(-60), deg_to_rad(150), 0), EULER_ORDER_XYZ), Vector3.ZERO)
	RenderingServer.instance_set_transform(light_instance, light_transform)
	RenderingServer.instance_set_scenario(light_instance, scenario)


func _process(delta: float) -> void:
	trans = trans.rotated(Vector3(0, 1, 1).normalized(), delta)
	RenderingServer.instance_set_transform(instance_mesh, trans)
