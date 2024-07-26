extends Node2D

onready var animated_sprite: AnimatedSprite = $animationDoor
onready var animated_portal: AnimatedSprite = $portal
onready var collision_shape : CollisionShape2D = $DoorPlayerDetector/DoorBody/CollisionShape2D
onready var audio_porta: AudioStreamPlayer2D = $porta

var color: String
var in_puzzle: bool = false
var puzzle_complete: bool = false

func _ready():
	Events.connect("door_puzzle", self, "_on_door_puzzle")
	Events.connect("interacted", self, "_on_interacted")
	_update_static_body_state()

func _on_door_puzzle(door):
	if (door == self):
		in_puzzle = true
		
		if self.get_parent().get_index() == 6:
			puzzle_complete = Storage.puzzle_complete
		if puzzle_complete:
			open_door()
		else:
			close_door()

func _on_interacted(door):
	if (door == self):
		puzzle_complete = true
		open_door()

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
		if in_puzzle and puzzle_complete:
			animated_sprite.play("opening_" + color)
		elif !in_puzzle:
			animated_sprite.play("opening_" + color)
	audio_porta.play()   

func close_door():
	if color:
		collision_shape.set_deferred("disabled", false)
		animated_sprite.play("closing_" + color) 
	audio_porta.play()  
	
func is_close_door():
	return animated_sprite.animation == "close_" + color
	
func is_open_door():
	return animated_sprite.animation == "open_" + color
	
func set_door(color):
	self.color = color
	if color == "red":
		animated_portal.play("boss")

