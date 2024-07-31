extends Node

var id_weapon_number = 3

var in_dialog = false

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	
	Events.connect("in_dialog", self, "_on_in_dialog")
	Events.connect("timeline_ended", self, "on_timeline_ended")

func _on_in_dialog():
	in_dialog = true

func on_timeline_ended():
	in_dialog = false

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE and event.is_pressed():
			menu()
	if event is InputEventJoypadButton:
		if event.button_index == JOY_START and event.is_pressed():
			menu()

func menu():
	if get_tree().current_scene.name == "World" and !in_dialog:
		if get_tree().paused:
			close_pause_menu()
		else:
			open_pause_menu()

func open_pause_menu():
	if not get_parent().has_node("pause"):
		var pack_pause = preload("res://scene/pause.tscn")
		var inst_pause = pack_pause.instance()
		get_parent().add_child(inst_pause)
		get_tree().paused = true

func close_pause_menu():
	if get_parent().has_node("pause"):
		get_parent().get_node("pause").queue_free()
		get_tree().paused = false
