extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node

var current_upgrades = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)


func on_level_up(current_level: int):
	var chosen_upgrade = upgrade_pool.pick_random() as AbilityUpgrade
	if chosen_upgrade == null:
		return
		
	# does our 'current upgrade' have a key that matches chosen upgrade
	var has_upgrade = current_upgrades.has(chosen_upgrade.id)
	# if our 'current upgrade' doesn't have key that matches chosen upgrade...
	# we are going to create a new object at the key (i.e. sword_rate) 
	if !has_upgrade:
		current_upgrades[chosen_upgrade.id] = {
			# store reference to the resource
			# pass in our chosen upgrade at resource key 
			"resource": chosen_upgrade, 
			"quantity": 1
		}
	# if our 'current upgrade' already exists in dictionary...
	# we will increment that selected upgrade by one
	else: 
		current_upgrades[chosen_upgrade.id]["quantity"] += 1
	
	print(current_upgrades)
