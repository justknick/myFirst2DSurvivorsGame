extends CanvasLayer

@onready var background_screen_player: AnimationPlayer = $BackgroundScreenAnimationPlayer
@onready var panel_container = $%PanelContainer


func _ready():
	# tween the panel and setup scale
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	# button commands
	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)
	# background animation
	background_screen_player.play("out")
	await background_screen_player.animation_finished


func set_defeat():
	%TitleLabel.text = "Defeated..."
	%DescriptionLabel.text = "You faint. You lose."


func on_restart_button_pressed():
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_quit_button_pressed():
	get_tree().quit()
