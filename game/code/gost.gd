extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	ghosting() # Call the ghosting function

func set_property(tx_pos, tx_scale):
	position = tx_pos
	scale = tx_scale

func ghosting():
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self, "self_modulate:a", Color(1, 1, 1, 0), 0.75)
	yield(tween_fade, "finished")
