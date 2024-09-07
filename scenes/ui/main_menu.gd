extends CanvasLayer

var options_menu = preload("res://scenes/ui/options_menu.tscn")
var path_game: String = "res://scenes/main/main.tscn"
var path_meta_upgrade: String = "res://scenes/ui/meta_menu.tscn"

func _ready():
	$%PlayButton.pressed.connect(on_play_pressed)
	$%MetaUpgradesButton.pressed.connect(on_upgrades_pressed)
	$%OptionsButton.pressed.connect(on_options_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)


func on_play_pressed():
	ScreenTransition.transition_to_scene(path_game)


func on_upgrades_pressed():
	ScreenTransition.transition_to_scene(path_meta_upgrade)


func on_options_pressed():
	# transition animation
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	var options_instance = options_menu.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


func on_options_closed(options_instance: Node):
	# transition animation
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	options_instance.queue_free()


func on_quit_pressed():
	get_tree().quit()
