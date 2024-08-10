extends Node

const SPAWN_RADIUS = 350

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer 

var base_spawn_time = 0


func _ready():
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


# func for enemy spawn rate 
func on_timer_timeout():
	# restart timer, update wait timer on next timeout signal
	timer.start()
	
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
	
	# now we'll place enemy node into scene tree, under entities layer
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = spawn_position 


func on_arena_difficulty_increased(arena_difficulty: int):
	# update wait_time here, wait for next timeout to use new wait_time
	var time_reduce = (0.1 / 12) * arena_difficulty
	
	# give time_reduce a limit - do not go smaller than 0.7
	time_reduce = min(time_reduce, .7)
	
	print(time_reduce)
	timer.wait_time = base_spawn_time - time_reduce
