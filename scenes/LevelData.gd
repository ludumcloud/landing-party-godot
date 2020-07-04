class_name LevelData

var map: TileMap

func _init(map_: TileMap):
	map = map_
	
	var positions = map.get_used_cells()
	var tile_set = map.tile_set
	for position in positions:
		var tile_id = map.get_cellv(position)
		
		print("Cell ", position, ": ", tile_id)
	print("This is in the LevelData")
