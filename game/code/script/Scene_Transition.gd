extends CanvasLayer

func _ready():
	pass

func change_scene(target: String):
	$AnimationPlayer.play("dissolve")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(target)
	$AnimationPlayer.play_backwards("dissolve")
