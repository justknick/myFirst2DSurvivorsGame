extends CanvasLayer


func _ready():
	GameEvents.player_damaged.connect(on_player_damanged)


func on_player_damanged():
	$AnimationPlayer.play("hit")
