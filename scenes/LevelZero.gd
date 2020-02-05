extends Node2D

signal redshirtEntered
signal redshirtExited

onready var nav: Navigation2D = $Navigation2D
onready var path: Line2D = $Line2D
onready var charater: Sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("redshirtEntered", Vector2(1,1))

var elapsed = 0
var once1 = true
var once2 = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed = elapsed + delta
	if elapsed > 3 && once1:
		emit_signal("redshirtEntered", Vector2(4,1))
		once1 = false
	if elapsed > 6 && once2:
		emit_signal("redshirtExited", Vector2(4,1))
		once2 = false

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		var map: TileMap = $Navigation2D/Floor
		var correctedPosition = map.map_to_world(map.world_to_map(event.global_position)) + (map.cell_size *0.5)
		path.points = nav.get_simple_path(charater.global_position, correctedPosition, false)
		
	if event is InputEventKey and event.scancode == KEY_ENTER:
		if path.points.size() != 0:
			charater.position = path.points[-1]
			path.points = PoolVector2Array()
