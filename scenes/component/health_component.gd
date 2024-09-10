extends Node
class_name HealthComponent

signal fainted
signal health_change
signal health_decrease

@export var max_health: float = 10 
var current_health 


func _ready():
	current_health = max_health


func damage(damage_amount:float):
	current_health = clamp(current_health - damage_amount, 0, max_health)
	# emit anytime health changes 
	health_change.emit()
	# emit when damage is positive, aka inflicted
	if damage_amount > 0:
		health_decrease.emit()
	Callable(check_fainted).call_deferred()


func heal(health_regeneration_quantity: int):
	damage(-health_regeneration_quantity)


func get_health_percent():
	if current_health <= 0:
		return 0
	return min(current_health / max_health, 1) 


func check_fainted():
	if current_health == 0:
		fainted.emit()
		owner.queue_free()
