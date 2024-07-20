extends Node

signal room_entered(room)
signal player_room_entered(body, room)
signal enemy_entered(room)
signal enemy_room_entered(body, room)
signal enemy_left(room)

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
