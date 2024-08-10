extends Node
class_name HealthComponent

signal fainted
signal health_change

@export var max_health: float = 10 
var current_health 


func _ready():
	current_health = max_health


func damage(damage_amount:float):
	current_health = max(current_health - damage_amount, 0)
	health_change.emit()
	Callable(check_fainted).call_deferred()


func get_health_percent():
	if current_health <= 0:
		return 0
	return min(current_health / max_health, 1) 


func check_fainted():
	if current_health == 0:
		fainted.emit()
		owner.queue_free()
