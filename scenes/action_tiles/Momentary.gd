extends Node2D

export(Dictionary) var args = {
	"offTileId": 0,
	"onTileId": 0,
	"targetNodeName": ""
}

var map_pos

func set_cell(tileId):
	get_parent().set_cell(map_pos.x, map_pos.y, tileId)

# Called when the node enters the scene tree for the first time.
func _ready():
	map_pos = get_parent().world_to_map(self.get_position())
	set_cell(args.offTileId)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Node2D_redshirtEntered(tile_coords):
	if (tile_coords == map_pos):
		set_cell(args.onTileId)
