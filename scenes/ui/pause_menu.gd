extends CanvasLayer

@onready var panel_container = %PanelContainer

var is_closing
var options_menu_scene = preload("res://scenes/ui/options_menu.tscn")
var path_main_menu: String = "res://scenes/ui/main_menu.tscn"


func _ready():
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	
	$%ResumeButton.pressed.connect(on_resume_pressed)
	$%OptionsButton.pressed.connect(on_options_pressed)
	$%QuitToTitleButton.pressed.connect(on_quit_to_title_pressed)
	$AnimationPlayer.play("default")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


# listen for pause action
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		close()
		# whatever current input event being sent through tree is, 
		#  it'll be marked as 'handled' and stop its propagation
		get_tree().root.set_input_as_handled()


func close():
	if is_closing:
		return
	is_closing = true
	
	$AnimationPlayer.play_backwards("default")
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	# release the pause state
	get_tree().paused = false
	queue_free()


func on_resume_pressed():
	close()


func on_options_pressed():
	# transition animation
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	var options_instance = options_menu_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


func on_options_closed(options_instance: Node):
	# transition animation
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	options_instance.queue_free()


func on_quit_to_title_pressed():
	# release the pause state
	get_tree().paused = false
	ScreenTransition.transition_to_scene(path_main_menu)
