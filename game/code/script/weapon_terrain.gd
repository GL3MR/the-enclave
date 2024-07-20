extends Area2D

export var id = 0

func _ready():
	if id >= global.id_weapon_number:
		$apparence.play("weapon" + str(id))
	else:
		queue_free()

func _on_weapon_terrain_body_entered(body):
	if body.is_in_group("hero"):
		body.id_weapon_number = id + 1
		global.id_weapon_number = id + 1
		queue_free()
