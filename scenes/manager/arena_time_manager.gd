extends Node

@onready var timer = $Timer
 

func  get_time_elapse():
	return timer.wait_time - timer.time_left
	

