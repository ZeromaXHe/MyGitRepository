class_name ResourceController


static func is_resource_placeable(tile_coord: Vector2i, type: ResourceTable.Enum) -> bool:
	# 超出地图范围的不处理
	if not MapController.is_in_map_tile(tile_coord):
		return false
	var tile_info: MapTileDO = MapController.get_map_tile_do_by_coord(tile_coord)
	return is_resource_placeable_terrain_and_landscape(type, tile_info.terrain, tile_info.landscape)


static func is_resource_placeable_terrain_and_landscape(resource: ResourceTable.Enum, \
		terrain: TerrainTable.Enum, landscape: LandscapeTable.Enum) -> bool:
	match resource:
		ResourceTable.Enum.EMPTY:
			return true
		ResourceTable.Enum.SILK:
			return landscape == LandscapeTable.Enum.FOREST
		ResourceTable.Enum.RELIC:
			return TerrainController.is_no_mountain_land_terrain(terrain)
		ResourceTable.Enum.COCOA_BEAN:
			return landscape == LandscapeTable.Enum.RAINFOREST
		ResourceTable.Enum.COFFEE:
			return terrain == TerrainTable.Enum.GRASS or landscape == LandscapeTable.Enum.RAINFOREST
		ResourceTable.Enum.MARBLE:
			return (terrain == TerrainTable.Enum.GRASS or terrain == TerrainTable.Enum.GRASS_HILL \
					or terrain == TerrainTable.Enum.PLAIN_HILL) \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.RICE:
			return terrain == TerrainTable.Enum.GRASS \
					and (landscape == LandscapeTable.Enum.EMPTY or landscape == LandscapeTable.Enum.SWAMP \
					or landscape == LandscapeTable.Enum.FLOOD)
		ResourceTable.Enum.WHEAT:
			return ((terrain == TerrainTable.Enum.PLAIN or terrain == TerrainTable.Enum.DESERT) \
					and landscape == LandscapeTable.Enum.FLOOD) \
					or (terrain == TerrainTable.Enum.PLAIN and landscape == LandscapeTable.Enum.EMPTY)
		ResourceTable.Enum.TRUFFLE:
			return landscape == LandscapeTable.Enum.FOREST or landscape == LandscapeTable.Enum.RAINFOREST \
					or landscape == LandscapeTable.Enum.SWAMP
		ResourceTable.Enum.ORANGE:
			return (terrain == TerrainTable.Enum.GRASS or terrain == TerrainTable.Enum.PLAIN) \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.DYE:
			return landscape == LandscapeTable.Enum.RAINFOREST or landscape == LandscapeTable.Enum.FOREST
		ResourceTable.Enum.COTTON:
			return ((terrain == TerrainTable.Enum.GRASS or terrain == TerrainTable.Enum.PLAIN \
					or terrain == TerrainTable.Enum.DESERT) and landscape == LandscapeTable.Enum.FLOOD) \
					or ((terrain == TerrainTable.Enum.GRASS or terrain == TerrainTable.Enum.PLAIN) \
					and landscape == LandscapeTable.Enum.EMPTY)
		ResourceTable.Enum.MERCURY:
			return terrain == TerrainTable.Enum.PLAIN \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.WRECKAGE:
			return terrain == TerrainTable.Enum.SHORE \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.TOBACCO:
			return ((terrain == TerrainTable.Enum.GRASS or terrain == TerrainTable.Enum.PLAIN) \
					and landscape == LandscapeTable.Enum.EMPTY) \
					or landscape == LandscapeTable.Enum.FOREST or landscape == LandscapeTable.Enum.RAINFOREST
		ResourceTable.Enum.COAL:
			return (terrain == TerrainTable.Enum.GRASS_HILL or terrain == TerrainTable.Enum.PLAIN_HILL) \
					and landscape == LandscapeTable.Enum.EMPTY
					# or landscape == LandscapeTable.Enum.FOREST 原版不支持
		ResourceTable.Enum.INCENSE:
			return (terrain == TerrainTable.Enum.DESERT or terrain == TerrainTable.Enum.PLAIN) \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.COW:
			return terrain == TerrainTable.Enum.GRASS and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.JADE:
			return (terrain == TerrainTable.Enum.GRASS or terrain == TerrainTable.Enum.PLAIN \
					or terrain == TerrainTable.Enum.TUNDRA) \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.CORN:
			return (terrain == TerrainTable.Enum.GRASS or terrain == TerrainTable.Enum.PLAIN) \
					and (landscape == LandscapeTable.Enum.FLOOD or landscape == LandscapeTable.Enum.EMPTY)
		ResourceTable.Enum.PEARL:
			return terrain == TerrainTable.Enum.SHORE and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.FUR:
			return terrain == TerrainTable.Enum.TUNDRA or landscape == LandscapeTable.Enum.FOREST
		ResourceTable.Enum.SALT:
			return (terrain == TerrainTable.Enum.DESERT or terrain == TerrainTable.Enum.PLAIN \
					or terrain == TerrainTable.Enum.TUNDRA) \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.STONE:
			return (terrain == TerrainTable.Enum.GRASS or terrain == TerrainTable.Enum.GRASS_HILL) \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.OIL:
			return ((terrain == TerrainTable.Enum.SHORE or terrain == TerrainTable.Enum.DESERT \
					or terrain == TerrainTable.Enum.TUNDRA or terrain == TerrainTable.Enum.SNOW) \
					and landscape == LandscapeTable.Enum.EMPTY) \
					or landscape == LandscapeTable.Enum.SWAMP
					# or (terrain == TerrainTable.Enum.DESERT and landscape == LandscapeTable.Enum.FLOOD) 原版不支持
		ResourceTable.Enum.GYPSUM:
			return (terrain == TerrainTable.Enum.PLAIN or terrain == TerrainTable.Enum.PLAIN_HILL \
					or terrain == TerrainTable.Enum.DESERT_HILL or terrain == TerrainTable.Enum.TUNDRA_HILL) \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.SALTPETER:
			# 注意原版和其他判定不一样
			return (terrain != TerrainTable.Enum.SNOW and TerrainController.is_flat_land_terrain(terrain) \
					and landscape == LandscapeTable.Enum.EMPTY) or landscape == LandscapeTable.Enum.FLOOD
		ResourceTable.Enum.SUGAR:
			return (terrain == TerrainTable.Enum.GRASS or terrain == TerrainTable.Enum.PLAIN \
					or terrain == TerrainTable.Enum.DESERT) \
					and (landscape == LandscapeTable.Enum.FLOOD or landscape == LandscapeTable.Enum.SWAMP)
		ResourceTable.Enum.SHEEP:
			return terrain != TerrainTable.Enum.SNOW_HILL and TerrainController.is_hill_land_terrain(terrain) \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.TEA:
			return (terrain == TerrainTable.Enum.GRASS or terrain == TerrainTable.Enum.GRASS_HILL) \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.WINE:
			return ((terrain == TerrainTable.Enum.GRASS or terrain == TerrainTable.Enum.PLAIN) \
					and landscape == LandscapeTable.Enum.EMPTY) or landscape == LandscapeTable.Enum.FOREST
		ResourceTable.Enum.HONEY:
			return (terrain == TerrainTable.Enum.GRASS or terrain == TerrainTable.Enum.PLAIN) \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.CRAB:
			return terrain == TerrainTable.Enum.SHORE and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.IVORY:
			return ((terrain == TerrainTable.Enum.DESERT or terrain == TerrainTable.Enum.PLAIN \
					or terrain == TerrainTable.Enum.PLAIN_HILL) and landscape == LandscapeTable.Enum.EMPTY) \
					or landscape == LandscapeTable.Enum.RAINFOREST or landscape == LandscapeTable.Enum.FOREST
		ResourceTable.Enum.DIAMOND:
			return (terrain != TerrainTable.Enum.SNOW_HILL and TerrainController.is_hill_land_terrain(terrain) \
					and landscape == LandscapeTable.Enum.EMPTY) or landscape == LandscapeTable.Enum.RAINFOREST
		ResourceTable.Enum.URANIUM:
			return (TerrainController.is_no_mountain_land_terrain(terrain) and landscape == LandscapeTable.Enum.EMPTY) \
					or landscape == LandscapeTable.Enum.RAINFOREST or landscape == LandscapeTable.Enum.FOREST
		ResourceTable.Enum.IRON:
			return terrain != TerrainTable.Enum.SNOW_HILL and TerrainController.is_hill_land_terrain(terrain) \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.COPPER:
			return TerrainController.is_hill_land_terrain(terrain) and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.ALUMINIUM:
			return (terrain == TerrainTable.Enum.DESERT or terrain == TerrainTable.Enum.DESERT_HILL \
					or terrain == TerrainTable.Enum.PLAIN) and landscape == LandscapeTable.Enum.EMPTY
					# or landscape == LandscapeTable.Enum.RAINFOREST 风云变幻的条件，原版不行
		ResourceTable.Enum.SILVER:
			return (terrain == TerrainTable.Enum.DESERT or terrain == TerrainTable.Enum.DESERT_HILL \
					or terrain == TerrainTable.Enum.TUNDRA or terrain == TerrainTable.Enum.TUNDRA_HILL) \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.SPICE:
			return landscape == LandscapeTable.Enum.RAINFOREST or landscape == LandscapeTable.Enum.FOREST
		ResourceTable.Enum.BANANA:
			return landscape == LandscapeTable.Enum.RAINFOREST
		ResourceTable.Enum.HORSE:
			return (terrain == TerrainTable.Enum.GRASS or terrain == TerrainTable.Enum.PLAIN) \
					and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.FISH:
			return terrain == TerrainTable.Enum.SHORE and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.WHALE:
			return terrain == TerrainTable.Enum.SHORE and landscape == LandscapeTable.Enum.EMPTY
		ResourceTable.Enum.DEER:
			return ((terrain == TerrainTable.Enum.TUNDRA or terrain == TerrainTable.Enum.TUNDRA_HILL) \
					and landscape == LandscapeTable.Enum.EMPTY) or landscape == LandscapeTable.Enum.FOREST
	return false
