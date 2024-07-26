extends Control

func _ready():
	pass 


func _on_AnimationPlayer_animation_finished(anim_name):
	SceneTransition.change_scene("res://scene/title_screen.tscn")
