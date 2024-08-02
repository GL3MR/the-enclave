extends KinematicBody2D

onready var cell: AnimatedSprite = $apparance

func _ready():
	pass

func set_cell(flip_h: bool = false, flip_v: bool = false, transpose: int = 0):
	cell.flip_h = flip_h
	cell.flip_v = flip_v
	cell.rotation_degrees = transpose


func _on_Area2D_body_entered(body):
	if body.is_in_group("hero"):
		$Area2D.set_deferred("monitoring", false)
		Events.emit_dragon_catch_player(body)
	if body.is_in_group("boss"):
		$Area2D.set_deferred("monitoring", false)
		Events.emit_dragon_catch_boss(body)
