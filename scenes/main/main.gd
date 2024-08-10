extends Node

@export var end_screen_scene: PackedScene


func _ready():
	%Player.health_component.fainted.connect(on_player_fainted)


func on_player_fainted():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
