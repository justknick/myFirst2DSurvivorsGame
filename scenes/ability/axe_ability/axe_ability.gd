extends Node2D

const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent

var base_rotation = Vector2.RIGHT


func _ready():
	# make base rotation random
	base_rotation = base_rotation.rotated(randf_range(0, TAU))
	
	# create a tween - a way to programmatically defining animations 
	# a way to animate any property like an animation player, but w more flexibility
	var tween = create_tween()
	# tween will go from value 0.0 to 2.0 over 3 secm while tweening, call tween_method
	tween.tween_method(tween_method, 0.0, 2.0, 3)
	# free axe when tween is done
	tween.tween_callback(queue_free)


func tween_method(rotations: float):
	# axe ability will rotate around player, but radius will expand 
	
	# parameter will get # of rotations that's happened 
	# get percentage value, use it to calulate our radius 
	var percent = rotations / 2
	var current_radius = percent * MAX_RADIUS
	# get direction by taking rotation * TAU, use that as 
	# ...rotation applied to RIGHT vector (0 degrees)
	var current_direction = base_rotation.rotated(rotations * TAU)
	
	# setting global position of axe 
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		# if player doesn't exist, stop moving axe
		return
	
	# axe will rotate around player 
	global_position = player.global_position + (current_direction * current_radius)
