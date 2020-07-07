extends Node2D
class_name BaseLevel

signal redshirtEntered
signal redshirtExited

onready var nav: Navigation2D = $Navigation2D
onready var path: Line2D = $Line2D
onready var player = $Player
onready var redshirt = $Redshirt01 # make this enumerated eventually
onready var map: TileMap = $Navigation2D/Floor
var characters: Array
var selectedChar: Character

var command_list = []
var destination_point = null # Single command mechanic for now use command list for real
var GAME_STATE_COMMAND = 1
var GAME_STATE_RESOLVE = 2
var game_state = GAME_STATE_COMMAND

# Called when the node enters the scene tree for the first time.
func _ready():
	characters = [player, redshirt]
	selectedChar = null

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
	var path = nav.get_simple_path(entity.global_position, tile_coordinate, false)
	if (path.size() > 0):
		# Replace the begining and end points of the path because reasons
		path.set(path.size()-1 ,tile_coordinate)
		path.set(0, entity.global_position)
	return path

func reset_char_moved_state():
	for character in characters:
		character.clear_hasmoved()

func get_character_at_point(point: Vector2):
	var centeredInput = center_world_coords(point)
	for character in characters:
		if centeredInput.is_equal_approx(center_world_coords(character.global_position)):
			return character

	return null

func select_character(character: Character):
	# Undo previous selection tints
	if selectedChar != null:
		selectedChar.set_modulate(Color(1,1,1,1))

	if character == null:
		selectedChar = null
		return

	# only let yet to move chars to be selectable
	if character.hasMoved:
		return

	selectedChar = character
	# Tint the newly selected char
	if selectedChar != null:
		selectedChar.set_modulate(Color(0.5,1, 0.5,1))

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

		# first see if we clicked on a character
		var selection = get_character_at_point(event.global_position)
		if (selection != null):
			select_character(selection)
			path.points = PoolVector2Array()
		elif selectedChar != null:
			path.points = get_travel_path(selectedChar, event.global_position)

	if event is InputEventKey and event.scancode == KEY_ENTER:
		if path.points.size() != 0:
			#destination_point = path.points[-1]
			selectedChar.move_to_pos(map.world_to_map(path.points[-1]))
			path.points = PoolVector2Array()
			select_character(null)
			game_state = GAME_STATE_RESOLVE

	if event is InputEventKey and event.scancode == KEY_SPACE:
		reset_char_moved_state()
