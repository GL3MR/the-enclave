extends Control

var world = preload("res://scene/World.tscn")

onready var rooms = [
	"Room16",
	"Room19",
	"Room20",
	"Room21",
	"Room22",
	"Room23",
]

func _ready():
	pass

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			get_tree().quit()
		else:
			Storage.boss_defeated = false
			randomize_battery_location()
			Storage.puzzle_complete = false
			Storage.tutorial_complete = false
			Storage.save_game_data()
			
			var _result = get_tree().change_scene("res://scene/World.tscn")
			_result = null

	if event is InputEventJoypadButton:
		if event.button_index == JOY_START:
			get_tree().quit()
		else:
			var _result = get_tree().change_scene("res://scene/World.tscn")
			_result = null

func randomize_battery_location():
	randomize()
	rooms.shuffle()
	var world_instance = world.instance()
	var selected_room_name = rooms[0]
	var selected_room = world_instance.get_node(selected_room_name)
	Storage.battery_localization = selected_room.name

