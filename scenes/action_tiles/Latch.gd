extends Node2D

# For Single trigger actions (one way switches)

export(Dictionary) var args = {
	"offTileId": 0,
	"onTileId": 0,
	"targetNodeNames": [""],
	"inverseTargetNodeNames": [""],
	"consumesRedshirt": false
}

var map_pos
var triggered = false

func set_cell(tileId):
	get_parent().set_cell(map_pos.x, map_pos.y, tileId)

# Called when the node enters the scene tree for the first time.
func _ready():
	map_pos = get_parent().world_to_map(self.get_position())
	set_cell(args.offTileId)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Node2D_redshirtEntered(tile_coords, triggerer: Character):
	print("over here")
	print(tile_coords)
	if (tile_coords == map_pos and not triggered):
		set_cell(args.onTileId)
		for target in args.targetNodeNames:
			get_parent().get_node(target).set_on()
		for target in args.inverseTargetNodeNames:
			get_parent().get_node(target).set_off()
		if (args.consumesRedshirt):
			triggerer.start_death()
		self.triggered = true
