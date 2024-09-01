extends CanvasLayer

var options_menu = preload("res://scenes/ui/options_menu.tscn")


func _ready():
	$%PlayButton.pressed.connect(on_play_pressed)
	$%OptionsButton.pressed.connect(on_options_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)


func on_play_pressed():
	# transition animation
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	# change to main game scene
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_options_pressed():
	# transition animation
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	var options_instance = options_menu.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


func on_quit_pressed():
	get_tree().quit()


func on_options_closed(options_instance: Node):
	# transition animation
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	options_instance.queue_free()
