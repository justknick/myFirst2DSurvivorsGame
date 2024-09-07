extends CanvasLayer

signal transition_halfway

var skip_emit = false


func transition():
	#skip_emit = false
	# play animation 
	play_animation()


func transition_to_scene(scene_path: String):
	# returns to main menu
	transition()
	await transition_halfway
	# change to destination scene
	get_tree().change_scene_to_file(scene_path)


func emit_transition_halfway():
	if skip_emit:
		skip_emit = false
		return
	
	transition_halfway.emit()


func play_animation():
	$AnimationPlayer.play("default")
	# await for transition_halfway signal to emit
	await transition_halfway
	# skip_emit switch, so transition_half doesn't emit after backwards
	skip_emit = true
	play_animation_backwards()


func play_animation_backwards():
	# play animation backwards
	$AnimationPlayer.play_backwards("default")
#	skip_emit = false
