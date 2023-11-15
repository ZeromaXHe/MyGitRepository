class_name MapTileDO
extends MySimSQL.DataObj


# 坐标
var coord: Vector2i
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


## TEMP
var units: Array[Unit] = []
var city: City = null
