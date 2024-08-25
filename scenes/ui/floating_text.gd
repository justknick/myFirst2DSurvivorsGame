extends Node2D


func _ready():
	pass


func start(text: String):
	$Label.text = text
	
	# start tween for floating text bounce 
	var tween = create_tween()
	tween.set_parallel()
	
	# tween to rise and disappear
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	# chain to follow up tween 
	tween.chain().tween_property(self, "global_position", global_position + (Vector2.UP * 48), .5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ZERO, .5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	# chain to release tween 
	tween.chain().tween_callback(queue_free)

#	# tween to scale 
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE * 1.5, .15)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, "scale", Vector2.ONE, .15)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
#	tween.chain().tween_callback(queue_free)
	

