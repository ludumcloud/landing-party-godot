extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var tileMap = self.get_node("./FloorMap")
	print(tileMap.get_used_cells())
	print(tileMap.map_to_world(Vector2(3, -1)))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	var tileMap = self.get_node("./FloorMap")
	draw_circle(tileMap.map_to_world(Vector2(3, 1)), 10, Color.red)
