class_name TerritoryBorderTileMap
extends TileMap


# 边界层索引
const BORDER_LAYER_IDX: int = 0
# 地形集索引
const TERRAIN_SET_IDX: int = 0
const LINE_TERRAIN_IDX: int = 0
const DASH_TERRAIN_IDX: int = 1


func paint_line_border(cells: Array[Vector2i]) -> void:
	set_cells_terrain_connect(BORDER_LAYER_IDX, cells, TERRAIN_SET_IDX, LINE_TERRAIN_IDX)


func paint_dash_border(cells: Array[Vector2i]) -> void:
	set_cells_terrain_connect(BORDER_LAYER_IDX, cells, TERRAIN_SET_IDX, DASH_TERRAIN_IDX)

