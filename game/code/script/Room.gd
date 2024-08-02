extends Node2D

onready var playerBody = null
onready var player_detector = $PlayerDetector
onready var ground = $PlayerDetector/ground
onready var spawn_area = $SpawnArea
onready var spawn_batery = $SpawnBatery
onready var timer_cooldown = $Cooldown

var batery = preload("res://scene/Batery.tscn")
var viper = preload("res://scene/viper.tscn")

var doors = []
var walls = []
var positions_spawn = []
var enemies_data = []

var spawn_area_tuotial3 = []

var enemies_in_room = 0
var is_tutorial: bool = false
var tutorial_complete: bool = false

var has_moved = false
var has_dashed = false
var has_attacked = false
var has_weapon_wheel_opened = false

var batery_catch = false

var set = 0

func _ready():
	batery_catch = false
	
	spawn_area_tuotial3 = [
		$SpawnArea/Spawn26,
		$SpawnArea/Spawn34,
		$SpawnArea/Spawn42,
		$SpawnArea/Spawn149,
		$SpawnArea/Spawn150,
		$SpawnArea/Spawn151,
		$SpawnArea/Spawn152,
		$SpawnArea/Spawn98,
		$SpawnArea/Spawn126,
		$SpawnArea/Spawn66,
		$SpawnArea/Spawn58,
		$SpawnArea/Spawn50
	]
	
	if self == self.get_parent().get_node("Room3"):
		spawn_viper_instance($SpawnArea/Spawn6.global_position)
	
	if self == self.get_parent().get_node("Room4"):
		for spawn in spawn_area_tuotial3:
			spawn_viper_instance(spawn.global_position)
	
	if get_name() == Storage.battery_localization and !Storage.puzzle_complete:
		spawn_batery_instance()
		
	find_doors()
	find_walls()
	find_positions_spawn()
	
func set_sinal():
	Events.connect("tutorial_player_moved", self, "_on_tutorial_player_moved")
	Events.connect("tutorial_player_dashed", self, "_on_tutorial_player_dashed")
	Events.connect("tutorial_player_attacked", self, "_on_tutorial_player_attacked")
	Events.connect("tutorial_weapon_wheel_opened", self, "_on_tutorial_weapon_wheel_opened")
	Events.connect("tutorial_player_passed_enemy", self, "_on_tutorial_player_passed_enemy")
	Events.connect("tutorial_puzzle_completed", self, "_on_tutorial_puzzle_completed")
	Events.connect("tutorial_enemy_dead", self, "_on_tutorial_enemy_dead")

func spawn_batery_instance():
	var new_batery = batery.instance()
	new_batery.global_position = spawn_batery.global_position
	get_parent().call_deferred("add_child", new_batery)

func spawn_viper_instance(position):
	var new_viper = viper.instance()
	new_viper.global_position = position
	new_viper.is_defect = true
	get_parent().call_deferred("add_child", new_viper)

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
		Events.emit_in_tutoriald(is_tutorial)
		if self == self.get_parent().get_node("Room7"):
			MusicManager.stop_all()
			var pack_boss = preload("res://scene/boss.tscn")
			var inst_boss = pack_boss.instance()
			inst_boss.global_position = $SpawnArea/Spawn135.global_position
			get_parent().call_deferred("add_child", inst_boss)
		if self == self.get_parent().get_node("Room6"):
			Storage.tutorial_complete = true
			Storage.save_game_data()
			
			if !doors[2].is_close_door():
					doors[2].close_door()
			
			if !doors[3].is_close_door():
					doors[3].close_door()
		
		playerBody = body
		
		spawn_enemies()
		
		update_doors()
		
		Events.emit_room_entered(self)
		timer_cooldown.start()
		
		if get_name() == Storage.battery_localization and !Storage.puzzle_complete and !batery_catch:
			batery_catch = true
			get_parent().start_dialogue("sala-bateria")
	if body.is_in_group("mob") or body.is_in_group("boss"):
		Events.emit_enemy_entered(self)
		Events.emit_enemy_room_entered(body,self)
		if playerBody:
			timer_cooldown.start()
		_on_enemy_entered()

func _on_PlayerDetector_body_exited(body):
	if body.name == "Player":
		playerBody = null
	if body.is_in_group("mob")  or body.is_in_group("boss"):
		Events.emit_enemy_left(self)
	
		_on_enemy_left()
		if get_name() == "Room7" and playerBody and playerBody.life != 0 and enemies_in_room == 0:
			get_parent().start_dialogue("final")

func _on_enemy_entered():
	enemies_in_room += 1
	update_doors()

func _on_enemy_left():
	enemies_in_room -= 1
	update_doors()

func update_doors():
	
	if enemies_in_room > 0 and !is_tutorial:
		if playerBody != null:
			for door in doors:
				if !door.is_close_door():
					door.close_door()
	else:
		for door in doors:
			if self == self.get_parent().get_node("Room6") and (door.get_name() == "DoorLeft" or door.get_name() == "DoorDown"):
				if !door.is_close_door():
					door.close_door()
			elif Storage.in_challenge and self == self.get_parent().get_node("Room6") and (door.get_name() == "DoorUp"):
				if !door.is_close_door():
					door.close_door()
			elif is_tutorial and !tutorial_complete:
				if !door.is_close_door():
					door.close_door()
			elif !door.is_open_door() and !is_tutorial:
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
	set = 0
	for enemy_data in enemies_data:
		var enemy_scene = enemy_data["enemy"]
		var quantity = enemy_data["qtd"]
		
		for i in range(quantity):
			var enemy_instance = enemy_scene.instance()
			var spawn_position = positions_spawn[set]
			set += 1
			enemy_instance.position = spawn_position
			get_parent().call_deferred("add_child", enemy_instance)

func positions_spawn_shuffle():
	positions_spawn.shuffle()

func open_one_door(door):
	if !door.is_open_door():
		door.open_door()

func _on_tutorial_player_moved():
	if playerBody:
		has_moved = true
		check_movement_tutorial_complete()

func _on_tutorial_player_dashed():
	if playerBody:
		has_dashed = true
		check_movement_tutorial_complete()

func check_movement_tutorial_complete():
	if has_moved and has_dashed:
		open_one_door($DoorLeft)

func _on_tutorial_enemy_dead(position):
	if playerBody:
		spawn_viper_instance(position)

func _on_tutorial_player_attacked():
	if playerBody:
		has_attacked = true
		check_attack_tutorial_complete()

func _on_tutorial_weapon_wheel_opened():
	if playerBody:
		has_weapon_wheel_opened = true
		check_attack_tutorial_complete()

func check_attack_tutorial_complete():
	if has_attacked and has_weapon_wheel_opened:
		tutorial_complete = true
		open_one_door($DoorUp)

func _on_tutorial_player_passed_enemy():
	if playerBody:
		tutorial_complete = true
		open_one_door($DoorRight)


func _on_Cooldow_timeout():
	Events.emit_player_room_entered(playerBody,self)
