extends Control

func _ready():
	global.change_cursor(4)

func _on_continue_pressed():
	Storage.load_game_data()
	SceneTransition.change_scene("res://scene/World.tscn")

func _on_leave_pressed():
	SceneTransition.change_scene("res://scene/title_screen.tscn")
