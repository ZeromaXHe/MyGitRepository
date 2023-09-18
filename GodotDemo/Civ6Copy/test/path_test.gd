extends Node2D

@onready var path: Path2D = $Path2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D


func _ready() -> void:
	var astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(0, 0, 1000, 1000)
	astar_grid.cell_size = Vector2(100, 100)
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	astar_grid.set_point_solid(Vector2i(1, 0), true)
	astar_grid.set_point_solid(Vector2i(2, 1), true)
	astar_grid.set_point_solid(Vector2i(3, 2), true)
	astar_grid.set_point_solid(Vector2i(0, 2), true)
	astar_grid.set_point_solid(Vector2i(1, 3), true)
	astar_grid.set_point_solid(Vector2i(2, 4), true)
	
	var path_points: PackedVector2Array = astar_grid.get_point_path(Vector2i(0, 0), Vector2i(3, 4))
	print(path_points)
	path.curve.clear_points()
	path.curve.point_count = path_points.size()
	for point in path_points:
		path.curve.add_point(point)


func _physics_process(delta: float) -> void:
	path_follow.progress_ratio += delta / 2.0
	if path_follow.progress_ratio > 1:
		path_follow.progress_ratio -= 1
