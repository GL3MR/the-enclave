extends Node

var id_weapon_number = 3
var id_weapon = 0

var in_dialog = false

var path_mira = [
	"res://assets/art/ui/png/mira_0.png", 
	"res://assets/art/ui/png/mira_1.png", 
	"res://assets/art/ui/png/mira_2.png",
	"res://assets/art/ui/png/mira.png",
	"res://assets/art/ui/png/pointer.png"
]

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
			change_cursor(id_weapon)
			close_pause_menu()
		else:
			change_cursor(4)
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
		
func change_cursor(id):
	if id != 4:
		Input.set_custom_mouse_cursor(load(path_mira[id]), 0, Vector2(32, 32))
		id_weapon = id
	else:
		Input.set_custom_mouse_cursor(load(path_mira[id]))
	
