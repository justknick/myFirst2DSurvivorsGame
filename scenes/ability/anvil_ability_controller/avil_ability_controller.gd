extends Node

const BASE_RANGE = 100
const BASE_DAMAGE: int = 15

@export var anvil_ability_scene: PackedScene


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	


func on_timer_timeout():
	# get player position
	var player = get_tree().get_first_node_in_group("player") as Node2D
	# check player exists
	if player == null:
		return
	
	# pick a spot in a circle between 0 and TAU 
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	# pick a spot between 0 and BASE RANGE
	var spawn_position = player.global_position + (direction * randf_range(0, BASE_RANGE))
	
	# do collision check - does not spawn beyond borders
	var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
	var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	# if there is a collision, reassign spawn position
	if !result.is_empty():
		spawn_position = result["position"]
	
	# spawn the anvil
	var anvil_ability = anvil_ability_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability)
	anvil_ability.global_position = spawn_position
	anvil_ability.hitbox_component.damage = BASE_DAMAGE
	
