extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D 


func _ready():
	$GPUParticles2D.texture = sprite.texture
	health_component.fainted.connect(on_fainted)


func on_fainted():
	if owner == null || not owner is Node2D:
		return
	# get enemy spawn position
	var spawn_position = owner.global_position 
	
	# get layer reference of entities in tree 
	var entities = get_tree().get_first_node_in_group("entities_layer")
	# move self to the entities layer 
	get_parent().remove_child(self)
	entities.add_child(self)
	
	# place self to the position of enemy
	global_position = spawn_position
	
	# play animation
	$AnimationPlayer.play("default")
	
	# play hit audio
	$RandomHitAudioStreamPlayer2D.play_random()
