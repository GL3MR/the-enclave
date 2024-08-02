extends Control

func _ready():
	global.change_cursor(4)
	MusicManager.play("Music_Menu")
	$AnimationPlayer.play("New Anim")

func _on_AnimationPlayer_animation_finished(anim_name):
	SceneTransition.change_scene("res://scene/title_screen.tscn")
