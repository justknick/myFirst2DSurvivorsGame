extends AudioStreamPlayer2D

@export var streams: Array[AudioStream]


func play_random():
	# check to make sure streams isn't empty
	if streams == null || streams.size() == 0:
		return
	# assign stream property to randomly chosen audio 
	stream = streams.pick_random() 
	play()
