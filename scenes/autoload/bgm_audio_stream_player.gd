extends AudioStreamPlayer


# music will play on start
func _ready():
	# when music is done playing, it'll connect to 'on_finished' method
	finished.connect(on_finished)
	# when timer is done, it'll connect to 'on_timer_timeout' method
	$Timer.timeout.connect(on_timer_timout)


# this function will start the timer (i.e. 10s)
func on_finished():
	$Timer.start()


# this function will play parent node, aka the music
func on_timer_timout():
	play()
