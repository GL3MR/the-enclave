extends Node

export var batery_count: int = 0

signal room_entered(room)
signal player_room_entered(body, room)
signal enemy_entered(room)
signal enemy_room_entered(body, room)
signal enemy_left(room)
signal interacted(door)
signal door_puzzle(door)
signal tutorial_player_moved()
signal tutorial_player_dashed()
signal tutorial_player_attacked()
signal tutorial_weapon_wheel_opened()
signal tutorial_player_passed_enemy()
signal tutorial_puzzle_completed()
signal tutorial_enemy_dead(position) 
signal in_dialog()
signal timeline_ended()
signal in_tutorial(in_tutorial)
signal in_interactive_zone(in_interactive_zone)
signal hit_player()

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

func emit_tutorial_player_moved():
	emit_signal("tutorial_player_moved")

func emit_tutorial_player_movedplayer_dashed():
	emit_signal("tutorial_player_movedplayer_dashed")

func emit_tutorial_player_movedplayer_attacked():
	emit_signal("tutorial_player_movedplayer_attacked")

func emit_tutorial_player_dashed():
	emit_signal("tutorial_player_dashed")

func emit_tutorial_player_attacked():
	emit_signal("tutorial_player_attacked")

func emit_tutorial_weapon_wheel_opened():
	emit_signal("tutorial_weapon_wheel_opened")

func emit_tutorial_player_passed_enemy():
	emit_signal("tutorial_player_passed_enemy")

func emit_tutorial_puzzle_completed():
	emit_signal("tutorial_puzzle_completed")

func emit_tutorial_enemy_dead(position):
	emit_signal("tutorial_enemy_dead", position)

func emit_in_dialog():
	emit_signal("in_dialog")

func emit_timeline_ended():
	emit_signal("timeline_ended")

func emit_in_tutoriald(in_tutorial):
	emit_signal("in_tutorial", in_tutorial)

func emit_in_interactive_zone(in_interactive_zone):
	emit_signal("in_interactive_zone", in_interactive_zone)

func emit_hit_player():
	emit_signal("hit_player")
