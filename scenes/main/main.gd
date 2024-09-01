extends Node

@export var end_screen_scene: PackedScene

var pause_menu_screen = preload("res://scenes/ui/pause_menu.tscn")


func _ready():
	%Player.health_component.fainted.connect(on_player_fainted)


# listen for pause action
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu_screen.instantiate())
		# whatever current input event being sent through tree is, 
		#  it'll be marked as 'handled' and stop its propagation
		get_tree().root.set_input_as_handled()


func on_player_fainted():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
