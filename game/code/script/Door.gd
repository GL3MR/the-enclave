extends Node2D

onready var animated_sprite: AnimatedSprite = $animationDoor
onready var collision_shape : CollisionShape2D = $DoorPlayerDetector/DoorBody/CollisionShape2D
onready var audio_porta: AudioStreamPlayer2D = $porta

var color: String

func _ready():
	_update_static_body_state()

func _on_AnimatedSprite_animation_finished():
	_update_static_body_state()

func _update_static_body_state():
	match animated_sprite.animation.split("_")[0]:
		"open":
			collision_shape.set_deferred("disabled", true)
		"close":
			collision_shape.set_deferred("disabled", false)
		"closing":
			collision_shape.set_deferred("disabled", false)
			animated_sprite.play("close_" + color)
		"opening":
			collision_shape.set_deferred("disabled", false)
			animated_sprite.play("open_" + color)
		_:
			collision_shape.set_deferred("disabled", false)

func open_door():
	if color:
		animated_sprite.play("opening_" + color)
	audio_porta.play()  

func close_door():
	if color:
		animated_sprite.play("closing_" + color) 
	audio_porta.play()  
	
func is_close_door():
	return animated_sprite.animation == "close_" + color
	
func is_open_door():
	return animated_sprite.animation == "open_" + color
	
func set_door(color):
	self.color = color

