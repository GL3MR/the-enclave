extends Control

func _ready():
	MusicManager.play("Music_Menu")
	global.change_cursor(4)

func _input(event):
	
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			get_tree().quit()
		else:
			
			SceneTransition.change_scene("res://scene/Menu.tscn")
	
	if event is InputEventMouseButton:
		SceneTransition.change_scene("res://scene/Menu.tscn")

	if event is InputEventJoypadButton:
		if event.button_index == JOY_START:
			get_tree().quit()
		else:
			SceneTransition.change_scene("res://scene/Menu.tscn")
