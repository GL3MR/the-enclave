extends RigidBody2D
var player
var localization
var parent


func _ready():
	parent = get_parent()
	player = parent.player

"""func _on_player_room_entered(body, room):
	print("Projectile: _on_player_room_entered")
	if is_in_room(room):
		player = body
func _on_enemy_room_entered(body, room):
	print("Projectile: _on_enemy_room_entered")
	if self == body:
		localization = room
func is_in_room(room):
	print("is_in_room")
	return localization == room
"""
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_TimeToLive_timeout():
	queue_free()



#func _on_SpirkProjectile_body_entered(body):
#	print("body entered")
#	if body == player:
#		print("hit")
#		player.hit(5)


func _on_Area2D_body_entered(body):
	if body is StaticBody2D:
		queue_free()
	if body is TileMap:
		queue_free()
	if body == player and !body.invinsible:
		player.hit(5)
		queue_free()
