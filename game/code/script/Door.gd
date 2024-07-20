extends Node2D

onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var collision_shape : CollisionShape2D = $DoorPlayerDetector/DoorBody/CollisionShape2D
onready var audio_porta: AudioStreamPlayer2D = $porta

func _ready():
	_update_static_body_state()

func _on_AnimatedSprite_animation_finished():
	_update_static_body_state()

func _update_static_body_state():
	match animated_sprite.animation:
		"open":
			collision_shape.set_deferred("disabled", true)
		"close":
			collision_shape.set_deferred("disabled", false)
		"closing":
			collision_shape.set_deferred("disabled", false)
			animated_sprite.play("close")
		"opening":
			collision_shape.set_deferred("disabled", false)
			animated_sprite.play("open")
		_:
			collision_shape.set_deferred("disabled", false)

func open_door():
	animated_sprite.play("opening")
	audio_porta.play()  

func close_door():
	animated_sprite.play("closing") 
	audio_porta.play()  
	
func is_close_door():
	return animated_sprite.animation == "close"
	
func is_open_door():
	return animated_sprite.animation == "open"

