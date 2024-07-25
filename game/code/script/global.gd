extends Node

var id_weapon_number = 3

func _ready():
	pause_mode = PAUSE_MODE_PROCESS

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE and event.is_pressed():
			menu()
	if event is InputEventJoypadButton:
		if event.button_index == JOY_START and event.is_pressed():
			menu()

func menu():
	if get_parent().has_node("pause"):
		get_parent().get_node("pause").queue_free()
		get_tree().paused = false
	else:
		get_tree().paused = true
		var pack_pause = preload("res://scene/pause.tscn")
		var inst_pause = pack_pause.instance()
		get_parent().add_child(inst_pause)
