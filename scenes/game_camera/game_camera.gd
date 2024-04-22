extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		# global position won't detect from player bc it doesn't know the 'exact' type of var 'player' is
		# by adding "as Node2D" at the end of declaring the player (see line 12), then intellisense will detect global position
		global_position = player.global_position
