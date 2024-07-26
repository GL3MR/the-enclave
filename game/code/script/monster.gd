extends KinematicBody2D 

var life = 4 
var damage = 1 

onready var player_a = get_tree().get_nodes_in_group("hero")
onready var player = player_a[0] 

var player_pos = Vector2(0, 0)
var mob_pos = Vector2(0, 0) 

enum direction {up, down, left, right }
var random 
var speed = 100 
var timer_move 
var can_move = false 
var timer_shoot  
var dir = Vector2(1, 0)

func _ready():
	move() 
	shoot()

func shoot():
	timer_shoot = Timer.new()
	timer_shoot.set_wait_time(1)
	timer_shoot.connect("timeout", self, "_on_timershoot_timeout")
	add_child(timer_shoot)
	timer_shoot.start()
	
	var pack_proj = preload("res://scene/projectile_monster.tscn")
	var inst_proj = pack_proj.instance() 
	inst_proj.init(false, 1, 50, 2, Vector2(4, 4), 4, dir, position, false, false)
	
	get_parent().call_deferred("add_child", inst_proj) 

func _on_timershoot_timeout():
	timer_shoot.queue_free()  
	shoot() 

func _physics_process(delta):
	player_pos = player.return_position() 
	mob_pos = self.position
		
	if can_move:
		random = randi() % 5 + 1 
		move() 
		
	if random == 1:
		move_and_slide(Vector2(speed, 0))
		direction.right
		rotation_degrees = 90
		dir = Vector2(1, 0)
	elif random == 2:
		move_and_slide(Vector2(-speed, 0))
		direction.left
		rotation_degrees = 270
		dir = Vector2(-1, 0)
	elif random == 3:
		move_and_slide(Vector2(0, speed))
		direction.down
		rotation_degrees = 180
		dir = Vector2(0, 1)
	elif random == 4:
		move_and_slide(Vector2(0, -speed)) 
		direction.up
		rotation_degrees = 0
		dir = Vector2(0, -1)

func damage(damage):
	life = max(0, life - damage) 
	$anim.play("degat")
	
	if life == 0:
		var doors = get_tree().get_nodes_in_group("door") 
		for door in doors:
			if door.nbofmob > 0:
				door.nbofmob -= 1
				if door.nbofmob == 0:
					door.open()
		queue_free()

func move():
	can_move = false
	timer_move = Timer.new()
	timer_move.set_wait_time(1)
	timer_move.connect("timeout", self, "_on_timermove_timeout")
	add_child(timer_move)
	timer_move.start()

func _on_timermove_timeout():
	timer_move.queue_free() 
	can_move = true

func _on_Area2D_body_entered(body):
	if body.is_in_group("hero"):
		body.hit(1) 
