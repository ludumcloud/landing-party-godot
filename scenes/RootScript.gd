extends Node2D

func _unhandled_input(event):
	if event is InputEventKey:
		get_tree().change_scene("res://scenes/LevelZero.tscn")
