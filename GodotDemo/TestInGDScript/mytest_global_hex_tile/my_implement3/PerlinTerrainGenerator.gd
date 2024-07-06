@tool
class_name PerlinTerrainGenerator
extends BaseTerrainGenerator


class ColorHeight:
	var color: Color
	var max_height: float
	
	func _init(color: Color, max_height: float) -> void:
		self.color = color
		self.max_height = max_height


@export_range(1, 8) var octaves: int = 1
@export_range(0, 1) var persistence: float = 0.5
@export_range(1, 10) var lacunarity: float = 2

@export var min_height: float = 0.0
@export var max_height: float = 10.0
@export var noise_scaling: float = 100.0

var color_heights: Array = [
	ColorHeight.new(Color.BLUE, 0.0),
	ColorHeight.new(Color.GREEN, 2.0),
	ColorHeight.new(Color.LIGHT_GREEN, 4.0),
	ColorHeight.new(Color.YELLOW, 6.0),
	ColorHeight.new(Color.YELLOW_GREEN, 8.0),
	ColorHeight.new(Color.WHITE, 10.0),
	]

static var perlin_noise: FastNoiseLite = FastNoiseLite.new()


func after_tile_creation(new_tile: HexTile) -> void:
	var height = floor(3 * ((max_height - min_height) * get_noise(new_tile.center.normalized().x, \
		new_tile.center.normalized().y, new_tile.center.normalized().z) + min_height)) / 3.0
	new_tile.height = height
	for i in range(color_heights.size() - 1, -1, -1):
		if height < (color_heights[i] as ColorHeight).max_height:
			new_tile.color = (color_heights[i] as ColorHeight).color


func get_noise(x: float, y: float, z: float) -> float:
	var value: float = 0.0
	var n_scale: float = noise_scaling
	var effect = 1.0
	for i in range(octaves):
		value += effect * perlin_noise_3d(n_scale * x, n_scale * y, n_scale * z)
		n_scale *= lacunarity
		effect *= 1 - persistence
	return value


func perlin_noise_3d(x: float, y: float, z: float) -> float:
	perlin_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	x += 15
	y += 25
	z += 35
	var xy: float = perlin_noise.get_noise_2d(x, y)
	var xz: float = perlin_noise.get_noise_2d(x, z)
	var yz: float = perlin_noise.get_noise_2d(y, z)
	var yx: float = perlin_noise.get_noise_2d(y, x)
	var zx: float = perlin_noise.get_noise_2d(z, x)
	var zy: float = perlin_noise.get_noise_2d(z, y)
	return (xy + xz + yz + yx + zx + zy) / 6
