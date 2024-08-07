extends Node

const SPAWN_RADIUS = 350

@export var basic_enemy_scene: PackedScene


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	


func on_timer_timeout():
	# want to spawn enemy
	# don't want to spawn on player
	var player = get_tree().get_first_node_in_group("player") as Node2D
	# want to make sure player exists - isn't KO'd 
	if player == null:
		return 
		
	# need to declare spawn distance from 0 to 2 tau 
	# RIGHT means the RIGHT direction, aka 0 degrees or 0 radians 
	# rand range will rotate location randomly between 0 and 2 pi (or 360 degrees) 
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	# need to declare spawn position - in any circular direction 'spawn rad' away 
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	
	# declare enemy to instantiate - this creates node, but doesn't put in scene tree
	var enemy = basic_enemy_scene.instantiate() as Node2D
	# now we'll place enemy node into scene tree 
	get_parent().add_child(enemy)
	enemy.global_position = spawn_position 
	
