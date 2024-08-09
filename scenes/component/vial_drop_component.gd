extends Node

@export_range(0, 1) var drop_percent: float = .5
@export var vial_scene: PackedScene
@export var health_component: Node


func _ready():
	(health_component as HealthComponent).fainted.connect(on_fainted)


func on_fainted():
	# on faint do the following: 
	# check random number is not greater than drop percentage
	if randf() > drop_percent:
		return
	
	# check if vial scene does not exist (or not defined)
	if vial_scene == null:
		return
		
	# want the vial spawn at the enemy's position 
	# check if 'owner' is not a Node2D
	if not owner is Node2D:
		return
	# now spawn the vial, under entities_layer
	var spawn_position = (owner as Node2D).global_position
	var vial_instance = vial_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(vial_instance)
	vial_instance.global_position = spawn_position
