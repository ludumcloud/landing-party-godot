extends Node2D

signal redshirtEntered


# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("redshirtEntered", Vector2(1,1))

var elapsed = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed = elapsed + delta
	if elapsed > 3:
		emit_signal("redshirtEntered", Vector2(4,1))
