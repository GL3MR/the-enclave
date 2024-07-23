extends Control

func _ready():
	pass

func _on_continue_pressed():
	global.menu()

func _on_relancer_pressed():
	global.menu()
	Storage.load_game_data()
	var _result = get_tree().change_scene("res://scene/World.tscn")
	_result = null

func _on_quitter_pressed():
	global.menu()
	var _result = get_tree().change_scene("res://scene/title_screen.tscn")
	_result = null
