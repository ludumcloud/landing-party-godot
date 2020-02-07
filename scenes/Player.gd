extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var next_pos = null

func center_world_coords(position):
	var map = get_parent().map
	var converted = map.map_to_world(map.world_to_map(position)) 
	var centered = converted + map.cell_size * 0.5
	return centered
	
func step_character(entity, destination_position, delta):
	var points = get_parent().get_travel_path(entity, destination_position)
	print(entity)
	print(destination_position)
	print(points)
	if points.size() > 2:
		# var vector = points[1] - points[0]
		# var new_position = points[0] * (vector * 0.001)
		entity.position = center_world_coords(points[2])
		# print(new_position)
		return false
	else:
		entity.position = points[0]
		return true

func move_to_pos(dest_tile_coords):
	next_pos = dest_tile_coords

func tile_coords_to_world(tile):
	print("Tile")
	print(tile)
	return get_parent().map.map_to_world(tile)

# Called when the node enters the scene tree for the first time.
var continue_nav
func _ready():
	pass
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if next_pos:
		continue_nav = step_character(self, tile_coords_to_world(next_pos), delta)
	else:
		continue_nav = false
		next_pos = null

