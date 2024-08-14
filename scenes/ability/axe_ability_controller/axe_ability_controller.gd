extends Node

@export var axe_ability_scene: PackedScene

var damage = 10


func _ready():
	$Timer.timeout.connect(on_timer_timeout)



func on_timer_timeout():
	# get player location
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return 
	
	# get foreground location 
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground_layer == null:
		return 
	
	# create axe instance
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	# add axe instance to the foreground location
	foreground_layer.add_child(axe_instance)
	# place axe location at player location
	axe_instance.global_position = player.global_position
	
	# axe will do damage
	axe_instance.hitbox_component.damage = damage


