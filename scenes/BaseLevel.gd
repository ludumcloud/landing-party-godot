extends Node2D
class_name BaseLevel

const LevelData = preload("res://scenes/LevelData.gd")

signal redshirtEntered
signal redshirtExited

onready var nav: Navigation2D = $Navigation2D
onready var path: Line2D = $Line2D
onready var player = $Player
onready var redshirt = $Redshirt01 # make this enumerated eventually
onready var map: TileMap = $Navigation2D/Floor
onready var level_data: LevelData
var entity_order: Array
var current_entity_idx: int

var command_list = []
var destination_point = null # Single command mechanic for now use command list for real
var GAME_STATE_COMMAND = 1
var GAME_STATE_RESOLVE = 2
var game_state = GAME_STATE_COMMAND


# Called when the node enters the scene tree for the first time.
func _ready():
	# level_data = LevelData.new(player, map, [redshirt])
	entity_order = [player, redshirt]
	current_entity_idx = 0
	
func redshirt_entered(position: Vector2, triggerer: Character):
	emit_signal("redshirtEntered", position, triggerer)
	
func redshirt_exited(position: Vector2, triggerer: Character):
	emit_signal("redshirtExited", position, triggerer)

func center_world_coords(position):
	var converted = map.map_to_world(map.world_to_map(position)) 
	var centered = converted + map.cell_size * 0.5
	return centered

func get_travel_path(entity, destination_world_pos):
	var tile_coordinate = center_world_coords(destination_world_pos)
	var travel_path = nav.get_simple_path(entity.global_position, tile_coordinate, false)
	if (travel_path.size() > 0):
		# Replace the begining and end points of the path because reasons
		travel_path.set(travel_path.size()-1 ,tile_coordinate)
		travel_path.set(0, entity.global_position)
	return travel_path

func _process(_delta):
	if game_state == GAME_STATE_COMMAND:
		return
		
	if destination_point == null:
		game_state = GAME_STATE_COMMAND

func _unhandled_input(event):
	if game_state != GAME_STATE_COMMAND:
		return

	var character = entity_order[current_entity_idx]

	if (event is InputEventMouseButton 
			and event.button_index == BUTTON_LEFT
			and event.is_pressed()):
		path.points = get_travel_path(character, event.global_position)

	if event is InputEventKey and event.scancode == KEY_ENTER:
		if path.points.size() != 0:
			#destination_point = path.points[-1]
			character.move_to_pos(map.world_to_map(path.points[-1]))
			path.points = PoolVector2Array()
			game_state = GAME_STATE_RESOLVE
			current_entity_idx = (current_entity_idx + 1) % entity_order.size()
