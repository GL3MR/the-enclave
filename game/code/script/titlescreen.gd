extends Control

func _ready():
	pass

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			get_tree().quit()
		else:
			var _result = get_tree().change_scene("res://scene/World.tscn")
			_result = null

	if event is InputEventJoypadButton:
		if event.button_index == JOY_START:
			get_tree().quit()
		else:
			var _result = get_tree().change_scene("res://scene/World.tscn")
			_result = null
