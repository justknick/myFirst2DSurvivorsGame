extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var hurt_box_component = $HurtBoxComponent



func _ready():
	hurt_box_component.hit.connect(on_hit)


func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	velocity_component.get_facing_direction(visuals)


func on_hit():
	$RandomHitAudioStreamPlayer2D.play_random()
