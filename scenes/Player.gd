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
	if points.size() > 1:
		var vector = points[1] - points[0]
		var normalized = vector.normalized()
		var magnitude = (normalized * 5)
		var new_position = points[0] + (normalized * (ENTITY_SPEED * delta))
		entity.position = new_position
		return false
	elif points.size() == 1:
		entity.position = points[0]
		return true
	else:
		# Do nothing
		return true

func move_to_pos(dest_tile_coords):
	next_pos = dest_tile_coords

func tile_coords_to_world(tile):
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
