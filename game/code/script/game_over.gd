extends Control

func _ready():
	pass

func _on_continue_pressed():
	Storage.load_game_data()
	get_tree().change_scene("res://scene/World.tscn")

func _on_leave_pressed():
	get_tree().change_scene("res://scene/title_screen.tscn")
