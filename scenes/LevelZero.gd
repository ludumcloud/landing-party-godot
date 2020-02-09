extends Node2D

signal redshirtEntered
signal redshirtExited

onready var nav: Navigation2D = $Navigation2D
onready var path: Line2D = $Line2D
onready var character = $Player
onready var map: TileMap = $Navigation2D/Floor

var command_list = []
var destination_point = null # Single command mechanic for now use command list for real
var GAME_STATE_COMMAND = 1
var GAME_STATE_RESOLVE = 2
var game_state = GAME_STATE_COMMAND

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func redshirt_entered(position: Vector2):
	emit_signal("redshirtEntered", position)
	
func redshirt_exited(position: Vector2):
	emit_signal("redshirtExited", position)

func center_world_coords(position):
	var converted = map.map_to_world(map.world_to_map(position)) 
	var centered = converted + map.cell_size * 0.5
	return centered

func get_travel_path(entity, destination_world_pos):
	var tile_coordinate = center_world_coords(destination_world_pos)
	return nav.get_simple_path(entity.global_position, tile_coordinate, false) 


func _process(delta):
	if game_state == GAME_STATE_COMMAND:
		return
		
	if destination_point == null:
		game_state = GAME_STATE_COMMAND

func _unhandled_input(event):
	if game_state != GAME_STATE_COMMAND:
		return

	if (event is InputEventMouseButton 
			and event.button_index == BUTTON_LEFT
			and event.is_pressed()):
		path.points = get_travel_path(character, event.global_position)

	if event is InputEventKey and event.scancode == KEY_ENTER:
		if path.points.size() != 0:
			#destination_point = path.points[-1]
			self.get_node("Player").move_to_pos(map.world_to_map(path.points[-1]))
			path.points = PoolVector2Array()
			game_state = GAME_STATE_RESOLVE
