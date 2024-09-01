extends CanvasLayer

signal back_pressed

@onready var sfx_slider = %SFXSlider
@onready var music_slider = %MusicSlider
@onready var window_button = %WindowButton
@onready var back_button = %BackButton


func _ready():
	# back button pressed will return to previous screen
	back_button.pressed.connect(on_back_pressed)
	# when window button is pressed, toggle between modes
	window_button.pressed.connect(on_window_button_pressed)
	# when SFX slider is changed, adjust volume
	sfx_slider.value_changed.connect(on_audio_slider_changes.bind("sfx"))
	# when Music slider is changed, adjust volume 
	music_slider.value_changed.connect(on_audio_slider_changes.bind("music"))
	update_display()


# want to change display anytime there is an update
func update_display():
	window_button.text = "Window"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Fullscreen"
	
	# display volume level for sfx and music 
	sfx_slider.value = get_bus_volume_percent("sfx")
	music_slider.value = get_bus_volume_percent("music")


# get current percentage of buses and convert to display value for sliders
func get_bus_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


# set current percentage of buses and convert to display value for sliders
func set_bus_volume_percent(percent: float, bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


# when player adjusts volume slider, set the bus value to match
func on_audio_slider_changes(value: float, bus_name: String):
	set_bus_volume_percent(value, bus_name)


# toggle window mode option between WINDOW and FULLSCREEN
func on_window_button_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	update_display()


# back button will return to previous screen
func on_back_pressed():
	back_pressed.emit()
