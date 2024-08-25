extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite = $Sprite2D


func _ready():
	$Area2D.area_entered.connect(on_area_entered)


# lerp between position pickup to player position per frame via percent 
func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	# calculate global position from vial position to player
	global_position = start_position.lerp(player.global_position, percent)
	
	# rotate vial when collecting
	var direction_from_start = player.global_position - start_position
	
	# 
	var target_rottion = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rottion, 1 - exp(-3 * get_process_delta_time()))


# collect the vial and disappear 
func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()


# disable collision so it doesn't occur twice
func disable_collision():
	collision_shape_2d.disabled = true


# tween method will run for 1 sec  
func on_area_entered(other_area: Area2D):
	# reference to disable collision outside of 'on area entered' process 
	Callable(disable_collision).call_deferred()
	
	# create animation using tween
	var tween = create_tween()
	# allow all tweens to run in parallel 
	tween.set_parallel()
	# tween 1 
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, .5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	# tween 2 
	tween.tween_property(sprite, "scale", Vector2.ZERO, .05).set_delay(.45)
	# tween chain will stop parallel above and then run the next tweens
	tween.chain()
	# tween 3
	tween.tween_callback(collect)
	

