extends AudioStreamPlayer2D

@export var streams: Array[AudioStream]
@export var randomize_pitch = true
@export var min_pitch = 0.8
@export var max_pitch = 1.2


func play_random():
	# check to make sure streams isn't empty
	if streams == null || streams.size() == 0:
		return
	
	# randomize audio pitch
	if randomize_pitch:
		pitch_scale = randf_range(min_pitch, max_pitch)
	else:
		pitch_scale = 1
	
	# assign stream property to randomly chosen audio 
	stream = streams.pick_random() 
	play()
