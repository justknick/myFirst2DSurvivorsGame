extends Node
class_name HealthComponent

signal fainted

@export var max_health: float = 10 
var current_health 


func _ready():
	current_health = max_health


func damage(damage_amount:float):
	current_health = max(current_health - damage_amount, 0)
	Callable(check_fainted).call_deferred()


func check_fainted():
	if current_health == 0:
		fainted.emit()
		owner.queue_free()
