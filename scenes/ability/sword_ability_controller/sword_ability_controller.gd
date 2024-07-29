extends Node
# Purpose is to  spawn the sword in an auto fashion to attack enemies

# Specify scene that corresponds to sword ability 
# Tells the type of variable that's being exported in the inspector
@export var sword_ability: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	# get_node("Timer"), or...
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	# we will place the location where the sword ability to appear
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	# the var will instantiate the ability, but not display anything
	# placed after player instance, bc we want to ensure player exists 
	var sword_instance = sword_ability.instantiate() as Node2D
	# we will add child node to the scene where player node is (i.e. main)
	player.get_parent().add_child(sword_instance)
	sword_instance.global_position = player.global_position
	
	
