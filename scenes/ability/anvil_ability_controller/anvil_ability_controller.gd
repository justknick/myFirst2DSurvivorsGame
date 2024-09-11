extends Node

const BASE_RANGE = 100
const BASE_DAMAGE: int = 15

@export var anvil_ability_scene: PackedScene

var anvil_count: int = 0


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	# get player position
	var player = get_tree().get_first_node_in_group("player") as Node2D
	# check player exists
	if player == null:
		return
	
	# pick a spot in a circle between 0 and TAU 
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	# divide anvil drop 
	var additional_rotation_degress = 360.0 / (anvil_count + 1)
	# make anvil drop symmetrical
	var anvil_distance = randf_range(0, BASE_RANGE)
	
	for i in (anvil_count + 1):
		var adjusted_direction = direction.rotated(deg_to_rad(i * additional_rotation_degress))
		# pick a spot between 0 and BASE RANGE
#		var spawn_position = player.global_position + (adjusted_direction * randf_range(0, BASE_RANGE))
		var spawn_position = player.global_position + (adjusted_direction * anvil_distance)
		
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


# this will listen to anvil ability upgrades
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "anvil_count":
		anvil_count = current_upgrades["anvil_count"]["quantity"] 
