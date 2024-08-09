extends Node
# Purpose is to  spawn the sword in an auto fashion to attack enemies

const MAX_RANGE = 150

# Specify scene that corresponds to sword ability 
# Tells the type of variable that's being exported in the inspector
@export var sword_ability: PackedScene

var damage = 5
var base_wait_time

# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = $Timer.wait_time
	# get_node("Timer"), or...
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	# we will place the location where the sword ability to appear
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
#		return false
	)
	
	if enemies.size() == 0:
		return 
	
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	# the var will instantiate the ability, but not display anything
	# placed after player instance, bc we want to ensure player exists 
	var sword_instance = sword_ability.instantiate() as SwordAbiliy
	# we will add child node to the scene where player node is (i.e. main)
	# we will add sword to the foreground_layer
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage
	
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	# will angle the sword toward the enemy
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


# this will listen to all ability upgrades
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	# will ignore upgrades that are not "sword_rate"
	if upgrade.id != "sword_rate":
		return 
	
	# when upgrades is "sword_rate", calculate new sword_rate
	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * .1
	$Timer.wait_time = base_wait_time * (1 - percent_reduction)
	$Timer.start()
