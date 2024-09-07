extends CanvasLayer

@onready var background_screen_player: AnimationPlayer = $BackgroundScreenAnimationPlayer
@onready var panel_container = $%PanelContainer

var path_main_menu: String = "res://scenes/ui/main_menu.tscn"
var path_continue_to_meta_menu: String = "res://scenes/ui/meta_menu.tscn"


func _ready():
	# tween the panel and setup scale
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	# button commands
	get_tree().paused = true
	%ContinueButton.pressed.connect(on_continue_button_pressed)
	%QuitToTitleButton.pressed.connect(on_quit_to_title_pressed)
	# background animation
	background_screen_player.play("out")
	await background_screen_player.animation_finished


func set_defeat():
	%TitleLabel.text = "Defeated..."
	%DescriptionLabel.text = "You faint. You lose."
	play_jingle(true)


func play_jingle(defeat: bool = false):
	if defeat:
		$DefeatAudioStreamPlayerComponent.play()
	else:
		$VictoryAudioStreamPlayerComponent.play()


func on_continue_button_pressed():
	ScreenTransition.transition_to_scene(path_continue_to_meta_menu)
	await ScreenTransition.transition_halfway
	get_tree().paused = false


func on_quit_to_title_pressed():
	ScreenTransition.transition_to_scene(path_main_menu)
	await ScreenTransition.transition_halfway
	get_tree().paused = false
