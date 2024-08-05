extends Control

func _ready():
	global.change_cursor(4)

func _on_jogar_pressed():
	SceneTransition.change_scene("res://scene/Menu_Jogar.tscn")

func _on_dev_pressed():
	SceneTransition.change_scene("res://scene/Desenvolvedores.tscn")

func _on_sair_pressed():
	get_tree().quit()
