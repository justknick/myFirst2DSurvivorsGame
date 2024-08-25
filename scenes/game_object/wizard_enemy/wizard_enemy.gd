extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent

var is_moving = false


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
