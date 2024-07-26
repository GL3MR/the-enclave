extends Control

onready var button_continuar = $VBoxContainer/continuar
onready var button_novo = $VBoxContainer/novo
onready var button_desafio = $VBoxContainer/desafio
onready var button_voltar = $VBoxContainer/voltar

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
	button_continuar.visible = Storage.in_game
	button_desafio.visible = true
	


func _on_continuar_pressed():
	Storage.load_game_data()
	SceneTransition.change_scene("res://scene/World.tscn")


func _on_novo_pressed():
	Storage.in_game = true
	Storage.in_challenge = false
	randomize_battery_location()
	Storage.puzzle_complete = false
	Storage.tutorial_complete = false
	Storage.save_game_data()
	
	SceneTransition.change_scene("res://scene/World.tscn")

func randomize_battery_location():
	randomize()
	rooms.shuffle()
	var world_instance = world.instance()
	var selected_room_name = rooms[0]
	var selected_room = world_instance.get_node(selected_room_name)
	Storage.battery_localization = selected_room.name

func _on_desafio_pressed():
	Storage.in_game = false
	Storage.in_challenge = true
	Storage.puzzle_complete = true
	Storage.tutorial_complete = true
	Storage.save_game_data()
	SceneTransition.change_scene("res://scene/World.tscn")


func _on_voltar_pressed():
	SceneTransition.change_scene("res://scene/Menu.tscn")
