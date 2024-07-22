extends Node2D

onready var playerBody = null
onready var player_detector = $PlayerDetector
onready var ground = $PlayerDetector/ground
onready var spawn_area = $SpawnArea

var doors = []
var walls = []
var positions_spawn = []
var enemies_data = []

var rng : RandomNumberGenerator

var enemies_in_room = 0

func _ready():
	find_doors()
	find_walls()
	find_positions_spawn()

func find_doors():
	for child in get_children():
		if child.name.begins_with("Door"):
			doors.append(child)

func find_walls():
	for child in get_children():
		if child.name.begins_with("Wall"):
			walls.append(child)

func find_positions_spawn():
	for position in spawn_area.get_children():
		if position is Position2D:
			positions_spawn.append(position.global_position)

func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		playerBody = body
		
		spawn_enemies()
		
		update_doors()
		
		Events.emit_room_entered(self)
		Events.emit_player_room_entered(body,self)
	if body.is_in_group("mob"):
		Events.emit_enemy_entered(self)
		Events.emit_enemy_room_entered(body,self)
		if playerBody:
			Events.emit_player_room_entered(playerBody,self)
		_on_enemy_entered()

func _on_PlayerDetector_body_exited(body):
	if body.name == "Player":
		playerBody = null
	if body.is_in_group("mob"):
		Events.emit_enemy_left(self)
		_on_enemy_left()

func _on_enemy_entered():
	enemies_in_room += 1
	update_doors()

func _on_enemy_left():
	enemies_in_room -= 1
	update_doors()

func update_doors():
	
	if enemies_in_room > 0:
		if playerBody != null:
			for door in doors:
				if !door.is_close_door():
					door.close_door()
	else:
		for door in doors:
			if !door.is_open_door():
				door.open_door()

func set_room(options):
	for j in range(doors.size()):
		var door = doors[j]
		var wall = walls[j]
		var option = options[j]
		
		if option == Enums.DoorColor.NONE:
			door.visible = false
			wall.visible = true
		else:
			door.set_door(Enums.door_color_to_string[option])
			door.visible = true
			wall.visible = false

func set_enemies(enemies_data):
	self.enemies_data = enemies_data

func spawn_enemies():
	positions_spawn_shuffle()
	set_enemies_in_room()

func set_enemies_in_room():
	for enemy_data in enemies_data:
		var enemy_scene = enemy_data["enemy"]
		var quantity = enemy_data["qtd"]
		
		for i in range(quantity):
			var enemy_instance = enemy_scene.instance()
			var spawn_position = positions_spawn[i]
			enemy_instance.position = spawn_position
			get_parent().call_deferred("add_child", enemy_instance)

	

func positions_spawn_shuffle():
	positions_spawn.shuffle()
