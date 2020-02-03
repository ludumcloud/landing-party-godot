extends Node2D


export(Dictionary) var args = {
	"onTileId": 0,
	"offTileId": 0,
	"initiallyOn": true
}

var map_pos

func set_cell(tileId):
	get_parent().set_cell(map_pos.x, map_pos.y, tileId)
	
func set_on():
	set_cell(args.onTileId)
	
func set_off():
	set_cell(args.offTileId)

# Called when the node enters the scene tree for the first time.
func _ready():
	map_pos = get_parent().world_to_map(self.get_position())
	if args.initiallyOn:
		set_cell(args.onTileId)
	else:
		set_cell(args.offTileId)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
