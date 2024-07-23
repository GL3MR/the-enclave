extends Node

export var batery_count: int = 0

signal room_entered(room)
signal player_room_entered(body, room)
signal enemy_entered(room)
signal enemy_room_entered(body, room)
signal enemy_left(room)
signal interacted(door)
signal door_puzzle(door)

func emit_room_entered(room):
	emit_signal("room_entered", room)
	
func emit_player_room_entered(body, room):
	emit_signal("player_room_entered", body, room)

func emit_enemy_entered(room):
	emit_signal("enemy_entered", room)
	
func emit_enemy_room_entered(body, room):
	emit_signal("enemy_room_entered", body, room)

func emit_enemy_left(room):
	emit_signal("enemy_left", room)

func emit_interacted(door):
	emit_signal("interacted", door)

func emit_door_puzzle(door):
	emit_signal("door_puzzle", door)
