extends TileMap


var action_tiles: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	for action_tile in action_tiles:
		print(action_tile.name)
	var legal_coords = self.get_used_cells()
	for coords in legal_coords:
		print(coords)

# Build the graph of legal positions a
# character on the map can occupy
func build_tile_graph():
	pass

# Return a set of points that represent a 
# valid path on the map that start at the
# "from" coordinate and end at the "to"
# coordinate
func path(from: Vector2, to: Vector2):
	pass
