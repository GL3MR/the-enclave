class_name actor
extends KinematicBody2D

export var speed = 100
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

var _velocity = Vector2.ZERO

const floor_normal = Vector2.UP

func _physics_process(delta):
	_velocity.y = _velocity.y
