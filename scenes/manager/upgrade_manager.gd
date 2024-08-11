extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)


# keep track of upgrades and have refeerence to upgraddes
func apply_upgrade(upgrade: AbilityUpgrade):
	# does our 'selected upgrade' have a key that matches the upgrade parameter?
	var has_upgrade = current_upgrades.has(upgrade.id)
	# if our 'selected upgrade' doesn't have key that matches upgrade...
	# we are going to create a new object at the key (i.e. sword_rate) 
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			# store reference to the resource
			# pass in our chosen upgrade at resource key 
			"resource": upgrade, 
			"quantity": 1
		}
	# if our 'selected upgrade' already exists in dictionary...
	# we will increment that selected upgrade by one
	else: 
		current_upgrades[upgrade.id]["quantity"] += 1
	
	GameEvents.emit_ability_upgrades_added(upgrade, current_upgrades)


func pick_upgrades():
	# to keep track of chosen upgrades
	var chosen_upgrades: Array[AbilityUpgrade] = []
	# make a copy of upgrade_pool array and use as reference 
	var filtered_upgrades = upgrade_pool.duplicate()
	
	for i in 2:
		var chosen_upgrade = filtered_upgrades.pick_random() as AbilityUpgrade
		# add each upgrade that we choose here
		chosen_upgrades.append(chosen_upgrade)
		# and then filtering them out 
		# filter func will iterate through every element from 
		#  filtered_upgrades array. Run the func in the parameter
		#  if in the func it returns true, the element stays in the array, 
		#  and if the func returns false, that element is filtered out 
		filtered_upgrades = filtered_upgrades.filter(func (upgrade): return upgrade.id != chosen_upgrade.id) 
		
	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade): 
	apply_upgrade(upgrade)


func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


