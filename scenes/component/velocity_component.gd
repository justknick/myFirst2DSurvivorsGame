extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5

var velocity = Vector2.ZERO


# func used to move toward the player 
func accelerate_to_player():
	# grab owner as node2d
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
	
	# get player 
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: 
		return
	
	# get direction
	var direction = (player.global_position - owner_node2d.global_position).normalized() 
	accelerate_in_direction(direction)


# func used to manipulate velocity 
func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	
	# accelerate current velocity toward desired velocity
	# use linear interpolate to take weight, go from current vel to desired vol 
	#  at a certain % rate 
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))


# func used to move the character by calling it 
func move(character_body: CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity


# the sprite will face the direction of player
func get_facing_direction(visuals):
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

