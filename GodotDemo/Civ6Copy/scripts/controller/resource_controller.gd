class_name ResourceController


static func is_resource_placeable(tile_coord: Vector2i, type: ResourceTable.ResourceType) -> bool:
	# 超出地图范围的不处理
	if not MapController.is_in_map_tile(tile_coord):
		return false
	var tile_info: MapTileDO = MapController.get_map_tile_do_by_coord(tile_coord)
	return is_resource_placeable_terrain_and_landscape(type, tile_info.terrain, tile_info.landscape)


static func is_resource_placeable_terrain_and_landscape(resource: ResourceTable.ResourceType, \
		terrain: TerrainTable.Terrain, landscape: LandscapeTable.Landscape) -> bool:
	match resource:
		ResourceTable.ResourceType.EMPTY:
			return true
		ResourceTable.ResourceType.SILK:
			return landscape == LandscapeTable.Landscape.FOREST
		ResourceTable.ResourceType.RELIC:
			return TerrainController.is_no_mountain_land_terrain(terrain)
		ResourceTable.ResourceType.COCOA_BEAN:
			return landscape == LandscapeTable.Landscape.RAINFOREST
		ResourceTable.ResourceType.COFFEE:
			return terrain == TerrainTable.Terrain.GRASS or landscape == LandscapeTable.Landscape.RAINFOREST
		ResourceTable.ResourceType.MARBLE:
			return (terrain == TerrainTable.Terrain.GRASS or terrain == TerrainTable.Terrain.GRASS_HILL \
					or terrain == TerrainTable.Terrain.PLAIN_HILL) \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.RICE:
			return terrain == TerrainTable.Terrain.GRASS \
					and (landscape == LandscapeTable.Landscape.EMPTY or landscape == LandscapeTable.Landscape.SWAMP \
					or landscape == LandscapeTable.Landscape.FLOOD)
		ResourceTable.ResourceType.WHEAT:
			return ((terrain == TerrainTable.Terrain.PLAIN or terrain == TerrainTable.Terrain.DESERT) \
					and landscape == LandscapeTable.Landscape.FLOOD) \
					or (terrain == TerrainTable.Terrain.PLAIN and landscape == LandscapeTable.Landscape.EMPTY)
		ResourceTable.ResourceType.TRUFFLE:
			return landscape == LandscapeTable.Landscape.FOREST or landscape == LandscapeTable.Landscape.RAINFOREST \
					or landscape == LandscapeTable.Landscape.SWAMP
		ResourceTable.ResourceType.ORANGE:
			return (terrain == TerrainTable.Terrain.GRASS or terrain == TerrainTable.Terrain.PLAIN) \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.DYE:
			return landscape == LandscapeTable.Landscape.RAINFOREST or landscape == LandscapeTable.Landscape.FOREST
		ResourceTable.ResourceType.COTTON:
			return ((terrain == TerrainTable.Terrain.GRASS or terrain == TerrainTable.Terrain.PLAIN \
					or terrain == TerrainTable.Terrain.DESERT) and landscape == LandscapeTable.Landscape.FLOOD) \
					or ((terrain == TerrainTable.Terrain.GRASS or terrain == TerrainTable.Terrain.PLAIN) \
					and landscape == LandscapeTable.Landscape.EMPTY)
		ResourceTable.ResourceType.MERCURY:
			return terrain == TerrainTable.Terrain.PLAIN \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.WRECKAGE:
			return terrain == TerrainTable.Terrain.SHORE \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.TOBACCO:
			return ((terrain == TerrainTable.Terrain.GRASS or terrain == TerrainTable.Terrain.PLAIN) \
					and landscape == LandscapeTable.Landscape.EMPTY) \
					or landscape == LandscapeTable.Landscape.FOREST or landscape == LandscapeTable.Landscape.RAINFOREST
		ResourceTable.ResourceType.COAL:
			return (terrain == TerrainTable.Terrain.GRASS_HILL or terrain == TerrainTable.Terrain.PLAIN_HILL) \
					and landscape == LandscapeTable.Landscape.EMPTY
					# or landscape == LandscapeTable.Landscape.FOREST 原版不支持
		ResourceTable.ResourceType.INCENSE:
			return (terrain == TerrainTable.Terrain.DESERT or terrain == TerrainTable.Terrain.PLAIN) \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.COW:
			return terrain == TerrainTable.Terrain.GRASS and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.JADE:
			return (terrain == TerrainTable.Terrain.GRASS or terrain == TerrainTable.Terrain.PLAIN \
					or terrain == TerrainTable.Terrain.TUNDRA) \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.CORN:
			return (terrain == TerrainTable.Terrain.GRASS or terrain == TerrainTable.Terrain.PLAIN) \
					and (landscape == LandscapeTable.Landscape.FLOOD or landscape == LandscapeTable.Landscape.EMPTY)
		ResourceTable.ResourceType.PEARL:
			return terrain == TerrainTable.Terrain.SHORE and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.FUR:
			return terrain == TerrainTable.Terrain.TUNDRA or landscape == LandscapeTable.Landscape.FOREST
		ResourceTable.ResourceType.SALT:
			return (terrain == TerrainTable.Terrain.DESERT or terrain == TerrainTable.Terrain.PLAIN \
					or terrain == TerrainTable.Terrain.TUNDRA) \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.STONE:
			return (terrain == TerrainTable.Terrain.GRASS or terrain == TerrainTable.Terrain.GRASS_HILL) \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.OIL:
			return ((terrain == TerrainTable.Terrain.SHORE or terrain == TerrainTable.Terrain.DESERT \
					or terrain == TerrainTable.Terrain.TUNDRA or terrain == TerrainTable.Terrain.SNOW) \
					and landscape == LandscapeTable.Landscape.EMPTY) \
					or landscape == LandscapeTable.Landscape.SWAMP
					# or (terrain == TerrainTable.Terrain.DESERT and landscape == LandscapeTable.Landscape.FLOOD) 原版不支持
		ResourceTable.ResourceType.GYPSUM:
			return (terrain == TerrainTable.Terrain.PLAIN or terrain == TerrainTable.Terrain.PLAIN_HILL \
					or terrain == TerrainTable.Terrain.DESERT_HILL or terrain == TerrainTable.Terrain.TUNDRA_HILL) \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.SALTPETER:
			# 注意原版和其他判定不一样
			return (terrain != TerrainTable.Terrain.SNOW and TerrainController.is_flat_land_terrain(terrain) \
					and landscape == LandscapeTable.Landscape.EMPTY) or landscape == LandscapeTable.Landscape.FLOOD
		ResourceTable.ResourceType.SUGAR:
			return (terrain == TerrainTable.Terrain.GRASS or terrain == TerrainTable.Terrain.PLAIN \
					or terrain == TerrainTable.Terrain.DESERT) \
					and (landscape == LandscapeTable.Landscape.FLOOD or landscape == LandscapeTable.Landscape.SWAMP)
		ResourceTable.ResourceType.SHEEP:
			return terrain != TerrainTable.Terrain.SNOW_HILL and TerrainController.is_hill_land_terrain(terrain) \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.TEA:
			return (terrain == TerrainTable.Terrain.GRASS or terrain == TerrainTable.Terrain.GRASS_HILL) \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.WINE:
			return ((terrain == TerrainTable.Terrain.GRASS or terrain == TerrainTable.Terrain.PLAIN) \
					and landscape == LandscapeTable.Landscape.EMPTY) or landscape == LandscapeTable.Landscape.FOREST
		ResourceTable.ResourceType.HONEY:
			return (terrain == TerrainTable.Terrain.GRASS or terrain == TerrainTable.Terrain.PLAIN) \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.CRAB:
			return terrain == TerrainTable.Terrain.SHORE and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.IVORY:
			return ((terrain == TerrainTable.Terrain.DESERT or terrain == TerrainTable.Terrain.PLAIN \
					or terrain == TerrainTable.Terrain.PLAIN_HILL) and landscape == LandscapeTable.Landscape.EMPTY) \
					or landscape == LandscapeTable.Landscape.RAINFOREST or landscape == LandscapeTable.Landscape.FOREST
		ResourceTable.ResourceType.DIAMOND:
			return (terrain != TerrainTable.Terrain.SNOW_HILL and TerrainController.is_hill_land_terrain(terrain) \
					and landscape == LandscapeTable.Landscape.EMPTY) or landscape == LandscapeTable.Landscape.RAINFOREST
		ResourceTable.ResourceType.URANIUM:
			return (TerrainController.is_no_mountain_land_terrain(terrain) and landscape == LandscapeTable.Landscape.EMPTY) \
					or landscape == LandscapeTable.Landscape.RAINFOREST or landscape == LandscapeTable.Landscape.FOREST
		ResourceTable.ResourceType.IRON:
			return terrain != TerrainTable.Terrain.SNOW_HILL and TerrainController.is_hill_land_terrain(terrain) \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.COPPER:
			return TerrainController.is_hill_land_terrain(terrain) and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.ALUMINIUM:
			return (terrain == TerrainTable.Terrain.DESERT or terrain == TerrainTable.Terrain.DESERT_HILL \
					or terrain == TerrainTable.Terrain.PLAIN) and landscape == LandscapeTable.Landscape.EMPTY
					# or landscape == LandscapeTable.Landscape.RAINFOREST 风云变幻的条件，原版不行
		ResourceTable.ResourceType.SILVER:
			return (terrain == TerrainTable.Terrain.DESERT or terrain == TerrainTable.Terrain.DESERT_HILL \
					or terrain == TerrainTable.Terrain.TUNDRA or terrain == TerrainTable.Terrain.TUNDRA_HILL) \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.SPICE:
			return landscape == LandscapeTable.Landscape.RAINFOREST or landscape == LandscapeTable.Landscape.FOREST
		ResourceTable.ResourceType.BANANA:
			return landscape == LandscapeTable.Landscape.RAINFOREST
		ResourceTable.ResourceType.HORSE:
			return (terrain == TerrainTable.Terrain.GRASS or terrain == TerrainTable.Terrain.PLAIN) \
					and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.FISH:
			return terrain == TerrainTable.Terrain.SHORE and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.WHALE:
			return terrain == TerrainTable.Terrain.SHORE and landscape == LandscapeTable.Landscape.EMPTY
		ResourceTable.ResourceType.DEER:
			return ((terrain == TerrainTable.Terrain.TUNDRA or terrain == TerrainTable.Terrain.TUNDRA_HILL) \
					and landscape == LandscapeTable.Landscape.EMPTY) or landscape == LandscapeTable.Landscape.FOREST
	return false
