extends Node

const SAVE_FILE_PATH = "user://game.save"


var save_data: Dictionary = {
	"meta_upgrade_currency": 0,
	"meta_upgrades": {}
}


func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_collected)
#	add_meta_upgrade(load("res://resources/meta_upgrades/experience_gain.tres"))
	load_save_file()


func load_save_file():
	# when save file is loaded, check if SAVE_FILE_PATH exists
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	# replace default save_data with whatever is in file 
	save_data = file.get_var()
#	print("Save Data: ", save_data)


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func add_meta_upgrade(upgrade: MetaUpgrade):
	# if upgrade isn't in the dictionary, add it 
	if not save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0
		}
	# upgrade quantity counter 
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1


func on_experience_collected(number: float):
	save_data["meta_upgrade_currency"] += number
	save()
