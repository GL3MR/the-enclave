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
	[],
	[],
	[],
	[],
	[],
	[],
	[
#		{"enemy": preload("res://scene/viper.tscn"), "qtd": 6},
#		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 6},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 2},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 2},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 2},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 2},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 2},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 2},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 3},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 3},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 3},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 3},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 2},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 2},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 2},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 2},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 3},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 3},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 5},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 5},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 3},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 3},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 3},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 3},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 5},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 5},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 5},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 5},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 5},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 5},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 5},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 5},
	],
	[
		{"enemy": preload("res://scene/viper.tscn"), "qtd": 5},
		{"enemy": preload("res://scene/Spirk.tscn"), "qtd": 5},
	]
]

var rooms_tutorial = []

onready var musica_ambiente: AudioStreamPlayer2D = $ambiente
onready var player: Node2D = $Player

var room_active
var in_dialog = false


func _ready():
	MusicManager.play("Music_Sala")
	Events.connect("room_entered", self, "_on_room_entered")
	
	global.change_cursor(0)
	
	rooms_tutorial = [
		$Room2,
		$Room3,
		$Room4,
		$Room5
	]
	
	Events.batery_count = 0
	
	if Storage.tutorial_complete:
		var offset = Vector2(192, 112)
		$Player.global_position = $Room6.global_position + offset
		$ZonasDialogos.queue_free()
	
	find_rooms()
	set_rooms()
	setup_rooms_with_enemies()

func _on_room_entered(room):
	room_active = room
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
			if rooms_tutorial.has(rooms[j]):
				rooms[j].is_tutorial = true
				rooms[j].set_sinal()
			
func setup_rooms_with_enemies():
	for i in range(rooms.size()):
		if i < enemies_rooms.size():
			var room = rooms[i]
			var enemies_data = enemies_rooms[i]
			room.set_enemies(enemies_data)
			

func _on_AreaTutorial3_body_entered(body):
	Events.emit_tutorial_player_passed_enemy()

func start_dialogue(dialogue_name: String):
	var dialogic = Dialogic.start(dialogue_name)
	call_deferred("add_child", dialogic)
	in_dialog = true
	$Timer.start()
	dialogic.connect("timeline_end", self, "_on_timeline_end")

func _on_timeline_end(timeline_name):
	in_dialog = false
	Events.emit_timeline_ended()
	if timeline_name == "final":
		Storage.in_game = false
		Storage.in_challenge = false
		Storage.boss_defeated = true
		Storage.save_game_data()
		SceneTransition.change_scene("res://scene/Credits.tscn")

func _on_Dialogo_Start_body_entered(body):
	start_dialogue("start")
	$ZonasDialogos/Dialogo_Start.queue_free()

func _on_Dialogo_Tutorial_1_body_entered(body):
	start_dialogue("tutorial-1")
	$ZonasDialogos/Dialogo_Tutorial_1.queue_free()

func _on_Dialogo_Tutorial_2_body_entered(body):
	start_dialogue("tutorial-2")
	$ZonasDialogos/Dialogo_Tutorial_2.queue_free()

func _on_Dialogo_Tutorial_3_body_entered(body):
	start_dialogue("tutorial-3")
	$ZonasDialogos/Dialogo_Tutorial_3.queue_free()

func _on_Dialogo_Tutorial_4_body_entered(body):
	start_dialogue("tutorial-4")
	$ZonasDialogos/Dialogo_Tutorial_4.queue_free()

func _on_Dialogo_sala_princial_tutorial_body_entered(body):
	start_dialogue("sala-principal-tutorial")
	$ZonasDialogos/Dialogo_sala_princial_tutorial.queue_free()
	$ZonasDialogos/Dialogo_sala_princial_sem_tutorial.queue_free()

func _on_Dialogo_sala_princial_sem_tutorial_body_entered(body):
	start_dialogue("sala-principal-sem-tutorial")
	$ZonasDialogos/Dialogo_sala_princial_tutorial.queue_free()
	$ZonasDialogos/Dialogo_sala_princial_sem_tutorial.queue_free()


func _on_Timer_timeout():
	Events.emit_in_dialog()
	
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_F and event.is_pressed() and !in_dialog:
			if room_active.get_name() == "Room2":
				start_dialogue("tutorial-1")
			if room_active.get_name() == "Room3":
				start_dialogue("tutorial-2")
			if room_active.get_name() == "Room4":
				start_dialogue("tutorial-3")
			if room_active.get_name() == "Room5":
				start_dialogue("tutorial-4")

func _exit_tree():
	Camera2d.position = Vector2(0,0)
