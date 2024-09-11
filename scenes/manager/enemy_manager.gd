extends Node

signal checkpoint_for_anvil(arena_difficulty: int)

const SPAWN_RADIUS = 350

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var bat_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer 

var base_spawn_time = 0
var enemy_table = WeightedTable.new()


func _ready():
	# add basic enemy to the enemy table 
	enemy_table.add_item(basic_enemy_scene, 10)
	# release enemy at end of timer
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	# need to declare enemy spawn distance from 0 to 2 tau 
	# RIGHT means the RIGHT direction, aka 0 degrees or 0 radians 
	# rand range will rotate location randomly between 0 and 2 pi (or 360 degrees) 
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	# perform check for physical boundaries, in a for loop
	for i in 4:
		# need to declare spawn position - in any circular direction 'spawn rad' away 
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		# additional check so enemy does not spawn ON the wall 
		var additional_check_offset = random_direction * 20
		
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		if result.is_empty():
			# we are clear - no collision
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


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
	
	# pick an enemy from the table from ready function
	var enemy_scene = enemy_table.pick_item()
	# declare enemy to instantiate - this creates node, but doesn't put in scene tree
	var enemy = enemy_scene.instantiate() as Node2D
	
	# now we'll place enemy node into scene tree, under entities layer
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	# update wait_time here, wait for next timeout to use new wait_time
	var time_reduce = (0.1 / 12) * arena_difficulty
	
	# give time_reduce a limit - do not go smaller than 0.7
	time_reduce = min(time_reduce, .7)
	
	print("Time Reduced: ", time_reduce)
	timer.wait_time = base_spawn_time - time_reduce
	
	# 30 sec in, spawn wizard
	if arena_difficulty == 6: 
		enemy_table.add_item(wizard_enemy_scene, 13)
	# 1 min, 30 sec in, spawn bat
	elif arena_difficulty == 18:
		enemy_table.add_item(bat_enemy_scene, 8)
	# 2 min in, add Anvil ability into pool
	elif arena_difficulty == 24:
		checkpoint_for_anvil.emit(arena_difficulty)


