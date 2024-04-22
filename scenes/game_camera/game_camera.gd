extends Camera2D

# CLASS NOTES: 
# global position won't detect from player bc it doesn't know the 'exact' 
# type of var 'player' is
# by adding "as Node2D" at the end of declaring the player (see line 12), 
# then intellisense will detect global position

var target_position = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 10)) 


# Acquire Target func - assign target position if player exists
func acquire_target():
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		target_position = player.global_position
