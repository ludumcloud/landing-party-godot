extends Node2D
class_name Character

var next_pos = null
var ENTITY_SPEED = 400 
onready var sprite: AnimatedSprite = get_node('AnimatedSprite')
onready var parent = get_parent();
onready var hasMoved = false;
	
func step_character(entity, destination_position, delta):
	var points = parent.get_travel_path(entity, destination_position)
	var distance = ENTITY_SPEED * delta
	if points.size() > 1:
		var vector = points[1] - points[0]
		if (vector.length() < distance) and (points.size() == 2):
			entity.position = parent.center_world_coords(points[1])
			return true
		var normalized = vector.normalized()
		var magnitude = (normalized * 5)
		var new_position = points[0] + (normalized * (ENTITY_SPEED * delta))
		entity.position = new_position
		return false
	elif points.size() == 1:
		entity.position = parent.center_world_coords(points[0])
		return true
	else:
		# Do nothing and mark completes
		return true

func move_to_pos(dest_tile_coords):
	next_pos = dest_tile_coords
	parent.redshirt_exited(world_coords_to_tile(self.position), self)

func tile_coords_to_world(tile):
	return parent.map.map_to_world(tile)
	
func world_coords_to_tile(world_coords):
	return parent.map.world_to_map(world_coords)

func start_death():
	#TODO we need to trigger death
	print("Something died....")
	return false

func _ready():
	pass
	
func _process(delta):
	if next_pos:
		sprite.play("walk")
		var complete = step_character(self, tile_coords_to_world(next_pos), delta)
		if complete:
			sprite.play("idle")
			parent.redshirt_entered(next_pos, self)
			next_pos = null
