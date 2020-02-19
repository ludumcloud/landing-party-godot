extends "res://scenes/abstract/StateInterface.gd"

onready var level = self.get_parent().get_parent()

func _ready():
	pass # Replace with function body.

func start():
	pass
	
func input(event):
	if (event is InputEventMouseButton 
			and event.button_index == BUTTON_LEFT
			and event.is_pressed()):
		level.set_path(event.global_position)

	if event is InputEventKey and event.scancode == KEY_ENTER:
		level.execute_path()
	
func physics_process(delta):
	pass
	
func stop():
	pass
