extends Node2D

var rooms = []

var options_rooms = [
	[Enums.DoorColor.BLUE, Enums.DoorColor.NONE, Enums.DoorColor.NONE, Enums.DoorColor.GREEN],
	[Enums.DoorColor.NONE, Enums.DoorColor.GREEN, Enums.DoorColor.NONE, Enums.DoorColor.GREEN],
	[Enums.DoorColor.GREEN, Enums.DoorColor.GREEN, Enums.DoorColor.NONE, Enums.DoorColor.NONE],
	[Enums.DoorColor.NONE, Enums.DoorColor.GREEN, Enums.DoorColor.GREEN, Enums.DoorColor.NONE],
	[Enums.DoorColor.NONE, Enums.DoorColor.GREEN, Enums.DoorColor.NONE, Enums.DoorColor.GREEN],
	[Enums.DoorColor.BLUE, Enums.DoorColor.RED, Enums.DoorColor.BLUE, Enums.DoorColor.GREEN],
	[Enums.DoorColor.NONE, Enums.DoorColor.NONE, Enums.DoorColor.NONE, Enums.DoorColor.RED],
	[Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE],
	[Enums.DoorColor.BLUE, Enums.DoorColor.NONE, Enums.DoorColor.NONE, Enums.DoorColor.BLUE],
	[Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.NONE, Enums.DoorColor.BLUE],
	[Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.NONE, Enums.DoorColor.NONE],
	[Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.NONE],
	[Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE],
	[Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE],
	[Enums.DoorColor.BLUE, Enums.DoorColor.NONE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE],
	[Enums.DoorColor.BLUE, Enums.DoorColor.NONE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE],
	[Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE],
	[Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE],
	[Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.NONE],
	[Enums.DoorColor.NONE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.NONE],
	[Enums.DoorColor.NONE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE],
	[Enums.DoorColor.NONE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE],
	[Enums.DoorColor.NONE, Enums.DoorColor.NONE, Enums.DoorColor.BLUE, Enums.DoorColor.BLUE],
]

var enemies_rooms = [
#	[],
#	[
#		{"enemy": preload("res://scene/viper.tscn"), "qtd": 5},
#	],
	[]
]

onready var musica_ambiente: AudioStreamPlayer2D = $ambiente
onready var player: Node2D = $Player

func _ready():
	Events.connect("room_entered", self, "_on_room_entered")
	
	Events.batery_count = 0
	
	if Storage.tutorial_complete:
		var offset = Vector2(192, 112)
		$Player.global_position = $Room6.global_position + offset
	
	find_rooms()
	set_rooms()
	setup_rooms_with_enemies()

func _on_room_entered(room):
	var offset = Vector2(192, 112)
	musica_ambiente.global_position = room.global_position + offset

func find_rooms():
	for child in get_children():
		if child.name.begins_with("Room"):
			rooms.append(child)

func set_rooms():
	for j in range(rooms.size()):
		if j < options_rooms.size():
			rooms[j].set_room(options_rooms[j])

func setup_rooms_with_enemies():
	for i in range(rooms.size()):
		if i < enemies_rooms.size():
			var room = rooms[i]
			var enemies_data = enemies_rooms[i]
			room.set_enemies(enemies_data)
			
