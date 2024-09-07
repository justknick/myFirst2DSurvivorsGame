extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container = $%GridContainer 

var meta_upgrade_card_scene = preload("res://scenes/ui/meta_upgrade_card.tscn")
var path_main_menu: String = "res://scenes/ui/main_menu.tscn"


func _ready():
	$%BackButton.pressed.connect(on_upgrades_back_pressed)
	# for dev purposes
	for child in grid_container.get_children():
		child.queue_free()
	
	for upgrade in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)


func on_upgrades_back_pressed():
	ScreenTransition.transition_to_scene(path_main_menu)
	# returns to main menu
#	ScreenTransition.transition()
#	await ScreenTransition.transition_halfway
#
#	# change to main game scene
#	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
