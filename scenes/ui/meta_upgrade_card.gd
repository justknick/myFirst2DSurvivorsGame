extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var progress_bar = $%ProgressBar
@onready var purchase_button = $%PurchaseButton
@onready var progress_label = %ProgressLabel

var upgrade: MetaUpgrade


# if a player clicks on a card, then that card will be chosen 
# then close screen and resume game 
func _ready():
	gui_input.connect(on_gui_input)
	purchase_button.pressed.connect(on_purchase_pressed)


# when meta cards drawn, assign each card an upgrade info
func set_meta_upgrade(upgrade: MetaUpgrade):
	self.upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()


# after purchase, want to update progress for the card 
func update_progress():
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = currency / upgrade.experience_cost
	# min = take which is smaller, percent or 1 
	percent = min(percent, 1)
	display_card_progress(currency, percent)


# animation on clicked card
func select_card():
	$AnimationPlayer.play("selected")


# displays card progress to determine if card can be purchased
func display_card_progress(currency: int, percent: float):
	# display the percentage into the 'value' 
	progress_bar.value = percent
	# if not enough experience cost, disable purchase button
	purchase_button.disabled = percent < 1
	progress_label.text = str(currency) + " / " + str(upgrade.experience_cost)


# command to click on a card
func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		select_card()


# upon purchase, add to the meta ugprade list
func on_purchase_pressed():
	if upgrade == null:
		return
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.experience_cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	select_card()
#	$AnimationPlayer.play("selected")
