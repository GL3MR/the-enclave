extends Control

func _ready():
	pass

func _on_continue_pressed():
	global.menu()

func _on_relancer_pressed():
	global.menu()
	Storage.load_game_data()
	SceneTransition.change_scene("res://scene/World.tscn")

func _on_quitter_pressed():
	global.menu()
	SceneTransition.change_scene("res://scene/title_screen.tscn")
