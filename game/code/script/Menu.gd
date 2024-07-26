extends Control

func _ready():
	pass 


func _on_jogar_pressed():
	SceneTransition.change_scene("res://scene/Menu_Jogar.tscn")


func _on_sair_pressed():
	get_tree().quit()
