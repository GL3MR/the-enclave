extends Node2D

onready var playerBody = null

onready var doors = [
	$DoorUp,
	$DoorDown,
	$DoorLeft,
	$DoorRight
]

var enemies_in_room = 0

func _ready():
	pass

func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		Events.emit_room_entered(self)
		Events.emit_player_room_entered(body,self)
		playerBody = body
		update_doors()
	if body.is_in_group("mob"):
		Events.emit_enemy_entered(self)
		Events.emit_enemy_room_entered(body,self)
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
