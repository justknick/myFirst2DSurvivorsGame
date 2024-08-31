extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var hurt_box_component = $HurtBoxComponent


func _ready():
	hurt_box_component.hit.connect(on_hit)


func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
#	var direction = get_direction_to_player()
#	velocity = direction * MAX_SPEED
#	move_and_slide()
	velocity_component.get_facing_direction(visuals)


#func get_direction_to_player():
#	var player_node = get_tree().get_first_node_in_group("player") as Node2D
#	if player_node != null:
#		return (player_node.global_position - global_position).normalized()
#	return Vector2.ZERO


func on_hit():
	$RandomHitAudioStreamPlayer2DHit.play_random()
