extends Node2D

signal redshirtEntered
signal redshirtExited


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
