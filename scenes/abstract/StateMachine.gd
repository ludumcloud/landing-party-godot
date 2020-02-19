extends Node

signal advance_state

var current_state = null
var action_queue = []
var run_actions = false

func init(initial_state):
	current_state = initial_state
	current_state.start()
	
func _run_action_queue(delta):
	if(!action_queue.empty()):
		var result = action_queue[0].call_func(delta)
		if !result:
			action_queue.pop_front()
	else:
		run_actions = false

func _ready():
	pass # Replace with function body.

func input(event):
	current_state.input(event)

func physics_process(delta):
	if run_actions:
		_run_action_queue(delta)
	else:
		current_state.physics_process(delta)

func change_state(new_state):
	run_actions = true
	current_state.stop()
	
	current_state = new_state
	current_state.start()
	
func add_action(action):
	action_queue.append(action)

#func _process(delta):
#	pass
