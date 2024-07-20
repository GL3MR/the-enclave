extends Node2D

onready var wall_body = $WallBody
onready var collision_shape = wall_body.get_node("CollisionShape2D")

func _ready():
	_update_collision_shape()

func _on_Wall_visibility_changed():
	_update_collision_shape()

func _update_collision_shape():
	if visible:
		collision_shape.set_deferred("disabled", false)
	else:
		collision_shape.set_deferred("disabled", true)
