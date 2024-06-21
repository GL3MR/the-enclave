class_name player
extends actor

var realIdWeapon = 1  # ID real da arma

const UP = Vector2(0, -1)
const ACCELERATION = 100
var can_pick = true

onready var animation_player = $animation

var target_rotation = 0
var target_rotation_current = 0

var dashSpeed = 150

var init_direction = Vector2(0, -1)  # Direção inicial do jogador
var direction = Vector2(0, 0)  # Direção real de movimento

var dashing = false  # Flag para verificar se o jogador está no modo "dash"
var attacking = false  # Flag para verificar se o jogador está atacando

var timer_dash  # Timer para o "dash"

func _physics_process(_delta):
	if not dashing and not attacking:
		
		if Input.is_action_pressed("ui_up") and direction.x == 0:
			if Input.is_action_pressed("ui_left"):
				move_and_slide(Vector2(-speed * sqrt(2) / 2, -speed * sqrt(2) / 2))
			elif Input.is_action_pressed("ui_right"):
				move_and_slide(Vector2(speed * sqrt(2) / 2, -speed * sqrt(2) / 2))
			else:
				move_and_slide(Vector2(0, -speed))
				direction.y = -1
			anim_switch("run")
			$ParticlesMove.emitting = true
			
		elif Input.is_action_pressed("ui_down") and direction.x == 0:
			if Input.is_action_pressed("ui_left"):
				move_and_slide(Vector2(-speed * sqrt(2) / 2, speed * sqrt(2) / 2))
			elif Input.is_action_pressed("ui_right"):
				move_and_slide(Vector2(speed * sqrt(2) / 2, speed * sqrt(2) / 2))
			else:
				move_and_slide(Vector2(0, speed))
				direction.y = 1
			anim_switch("run")
			$ParticlesMove.emitting = true
			
		elif Input.is_action_pressed("ui_right") and direction.y == 0:
			if Input.is_action_pressed("ui_down"):
				move_and_slide(Vector2(speed * sqrt(2) / 2, speed * sqrt(2) / 2))
			elif Input.is_action_pressed("ui_up"):
				move_and_slide(Vector2(speed * sqrt(2) / 2, -speed * sqrt(2) / 2))
			else:
				move_and_slide(Vector2(speed, 0))
				direction.x = 1
			anim_switch("run")
			$ParticlesMove.emitting = true
			
		elif Input.is_action_pressed("ui_left") and direction.y == 0:
			if Input.is_action_pressed("ui_down"):
				move_and_slide(Vector2(-speed * sqrt(2) / 2, speed * sqrt(2) / 2))
			elif Input.is_action_pressed("ui_up"):
				move_and_slide(Vector2(-speed * sqrt(2) / 2, -speed * sqrt(2) / 2))
			else:
				move_and_slide(Vector2(-speed, 0))
				direction.x = -1
			anim_switch("run")
			$ParticlesMove.emitting = true
		else:
			direction = Vector2(0, 0)
			anim_switch("idle")
		
		target_rotation = direction.angle()
		
		var look_vec = get_global_mouse_position() - global_position
		
		if direction != Vector2(0, 0):
			if(target_rotation != target_rotation_current):
				$ParticlesMove.restart()
				$ParticlesMove.rotation_degrees = rad2deg(target_rotation)
		
		if look_vec.x != 0:
			$sprite.flip_h = look_vec.x < 0
			
			if $sprite.flip_h:
				$Camera2D/Position2D.position.x *= -1
				$Sprite.position.x = -0.4
			else:
				$Sprite.position.x = 0.4
		else:
			pass
		
		if direction != Vector2(0, 0):
			init_direction = direction
		
		if Input.is_action_just_pressed("Special"):
			if realIdWeapon == 1:
				dash()
	
	elif dashing:
		move_and_slide(init_direction * dashSpeed)
	target_rotation_current = direction.angle()

func dash():
	dashing = true
	timer_dash = Timer.new()
	timer_dash.set_wait_time(0.5)
	timer_dash.connect("timeout", self, "_on_timerdash_timeout")
	add_child(timer_dash)
	timer_dash.start()
	anim_switch("dash")

func attaque():
	pass

func _on_timerdash_timeout():
    timer_dash.queue_free()
    dashing = false

func anim_switch(animation):
	var new_anim = str(animation)
	if animation_player.current_animation != new_anim:
		animation_player.play(new_anim)
