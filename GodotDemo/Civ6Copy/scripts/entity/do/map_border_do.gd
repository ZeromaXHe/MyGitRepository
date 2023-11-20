class_name MapBorderDO
extends MySimSQL.DataObj


# 坐标
var coord: Vector2i
# 地块类型
var tile_type := MapBorderTable.Enum.EMPTY


func clone() -> MapBorderDO:
	var result := MapBorderDO.new()
	result.coord = self.coord
	result.tile_type = self.tile_type
	return result
