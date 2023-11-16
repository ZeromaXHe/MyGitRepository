class_name MapTileDO
extends MySimSQL.DataObj


# 坐标
var coord: Vector2i
# 所属城市 id
var city_id: int
# 地形 id
var terrain := TerrainTable.Terrain.OCEAN # 海洋
# 地貌 id
var landscape := LandscapeTable.Landscape.EMPTY # 空
# 村庄
var village: bool = false
# 资源 id
var resource := ResourceTable.ResourceType.EMPTY # 空
# 大洲 id
var continent := ContinentTable.Continent.EMPTY # 空
