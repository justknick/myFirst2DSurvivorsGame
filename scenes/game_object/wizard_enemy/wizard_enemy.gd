extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var hurt_box_component = $HurtBoxComponent

var is_moving = false


func _ready():
	hurt_box_component.hit.connect(on_hit)


func _process(delta):
	# wizard movement will have a slight pause
	if is_moving:
		velocity_component.accelerate_to_player()
	else: 
		velocity_component.decelerate()
	
	velocity_component.move(self)
	velocity_component.get_facing_direction(visuals)


func set_is_moving(moving: bool):
	is_moving = moving


func on_hit():
	$RandomHitAudioStreamPlayer2D.play_random()
