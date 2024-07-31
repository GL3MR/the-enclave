extends KinematicBody2D

onready var animation_player = $anim
var can_pick = true
var target_rotation = 0
var target_rotation_current = 0

var life: int
var max_life = 25
var timer = null 
var speed = 100  
var dash_speed = 160 
var invinsible = false 

var flip = true

var stat_weapon = [
	{"damage_": 2, "speed_": 10, "lifespan_": 0.3, "dimension_": Vector2(22, 38), "rotate_": true}, 
	{"damage_": 1, "speed_": 400, "lifespan_": 1, "dimension_": Vector2(9, 6), "rotate_": true}, 
	{"damage_": 3, "speed_": 0, "lifespan_": 0.7, "dimension_": Vector2(28, 10), "rotate_": true}
]

var id_weapon = 0  
var id_weapon_number = global.id_weapon_number 
var action = 1 

var path_weapon = [
	"res://assets/art/ui/png/weapon-menu-saber.png", 
	"res://assets/art/ui/png/weapon-menu-buster.png", 
	"res://assets/art/ui/png/weapon-menu-puncher.png",
]

export var position_player = Vector2(0, 0) 
var direction = Vector2(0, -1)  
var true_direction = Vector2(0, 0)
var dashing = false 
var atacking = false 
var dying = false 

var timer_dash
var timer_att
var timer_damage
var timer_death

var angle_weapon_1 = 0

var in_dialog = false

func _ready():
	
	life = max_life
	$hud/lifebar.value = life * 3  

	$weapon.play(str(id_weapon))
	
	Events.connect("in_dialog", self, "_on_in_dialog")
	Events.connect("timeline_ended", self, "on_timeline_ended")
	Events.connect("in_tutorial", self, "on_in_tutorial")
	Events.connect("in_interactive_zone", self, "on_in_interactive_zone")

func on_in_tutorial(in_tutorial):
	$hud/fala.visible = in_tutorial

func on_in_interactive_zone(in_interactive_zone):
	$hud/interagir.visible = in_interactive_zone

func _physics_process(delta):
	$hud/lifebar.value = life * 3
	
	$hud/Batery_Count.text = str(Events.batery_count).pad_zeros(2)
	
	var dir = get_direction()

	var angle 
	angle =  rad2deg(atan2(dir.y, dir.x))

	if(id_weapon == 1 or id_weapon == 2):
		$weapon.rotation_degrees = angle + 90
#		$weapon.position.y = 8
	else:
		$weapon.rotation_degrees = angle + angle_weapon_1

	if in_dialog:
		anim_switch("idle")
	elif not dashing and not dying and not (id_weapon == 2 and atacking):
		true_direction = Vector2.ZERO
		
		Events.emit_tutorial_player_moved()
		
		if Input.is_action_pressed("move_right"):
			true_direction.x += 1
		if Input.is_action_pressed("move_left"):
			true_direction.x -= 1
		if Input.is_action_pressed("move_down"):
			true_direction.y += 1
		if Input.is_action_pressed("move_up"):
			true_direction.y -= 1

		true_direction = true_direction.normalized()

		if true_direction != Vector2.ZERO:
			move_and_slide(true_direction * speed)
			anim_switch("run")
			if !$walk.playing:
				$walk.play()
			$ParticlesMove.emitting = true
		else:
			anim_switch("idle")

		target_rotation = direction.angle()
		var look_vec = get_global_mouse_position() - global_position

		if true_direction != Vector2.ZERO and target_rotation != target_rotation_current:
			$ParticlesMove.restart()
			$ParticlesMove.rotation_degrees = rad2deg(target_rotation)

		if look_vec.x != 0:
			$sprite.flip_h = look_vec.x < 0

			if $sprite.flip_h:
				$shadow.position.x = -1
				
#				if(id_weapon == 1 or id_weapon == 2):
#					$weapon.position.x = -4
#				else:
#					$weapon.position.x = -6
				
				flip = false
			else:
				$shadow.position.x = 0
				
#				if(id_weapon == 1 or id_weapon == 2):
#					$weapon.position.x = 4
#				else:
#					$weapon.position.x = 6
				
				
				flip = true

		if true_direction != Vector2.ZERO:
			direction = true_direction

		if Input.is_action_just_pressed("switch"):
			switch()

		if Input.is_action_just_pressed("Special"):
			if action == 1:
				dash()

		elif Input.is_action_just_pressed("attaque") and not has_node("InGameMenu") and not atacking:
			attack()

	elif dashing:
		move_and_slide(direction * dash_speed)
		
		if Input.is_action_just_pressed("attaque") and not has_node("InGameMenu") and not atacking and !(id_weapon == 2):
			attack()
	elif !dying:
		$anim.play("idle")

func _on_in_dialog():
	in_dialog = true

func on_timeline_ended():
	in_dialog = false

	if in_dialog:
		anim_switch("idle")

func switch_weapon_up():
	id_weapon = (id_weapon + 1) % id_weapon_number
	apparence_hud()

func switch_weapon_down():
	id_weapon = (id_weapon - 1 + id_weapon_number) % id_weapon_number
	apparence_hud()

func switch():
	Events.emit_tutorial_weapon_wheel_opened()
	id_weapon = (id_weapon + 1) % id_weapon_number
	if not has_node("InGameMenu"):
		var pack_menu = preload("res://scene/item_menu.tscn")
		var inst_menu = pack_menu.instance()
		add_child(inst_menu)
		inst_menu.switch(id_weapon)
	else:
		$InGameMenu.switch(id_weapon)
	apparence_hud()
	$weapon.play(str(id_weapon))

func apparence_hud():
	$hud/weapon_switch.set_texture(load(path_weapon[id_weapon]))

func dash():
	Events.emit_tutorial_player_dashed()
	dashing = true
	timer_dash = Timer.new()
	timer_dash.set_wait_time(0.2)
	timer_dash.connect("timeout", self, "_on_timerdash_timeout")
	add_child(timer_dash)
	timer_dash.start()
	anim_switch("dash")
	$dash.play()
	if true_direction == Vector2.ZERO:
		true_direction = direction
	direction = true_direction 

func attack():
	if angle_weapon_1 == 0:
		angle_weapon_1 = 180
	else:
		angle_weapon_1 = 0
	var pack_proj = preload("res://scene/projectile.tscn")
	var inst_proj = pack_proj.instance()
	var stat = stat_weapon[id_weapon]
	atacking = true
	if id_weapon == 2:
		$weapon.visible = false
	timer_att = Timer.new()
	if id_weapon == 1:
		timer_att.set_wait_time(0.2)
	else:
		timer_att.set_wait_time(stat.lifespan_)
	timer_att.connect("timeout", self, "_on_timeratt_timeout")
	add_child(timer_att)
	timer_att.start()
	inst_proj.init(true, stat.damage_, stat.speed_, stat.lifespan_, stat.dimension_, id_weapon, get_direction(), $weapon.global_position, stat.rotate_, flip)
	get_parent().add_child(inst_proj)
	inst_proj.raise()
	if id_weapon != 2:
		$weapon.play("attack_" + (str(id_weapon)))

func hit(dmg):
	if not invinsible and life != 0:
		Events.emit_hit_player()
		invinsible = true
		life = max(0, life - dmg)
		timer_damage = Timer.new()
		timer_damage.set_wait_time(.5)
		timer_damage.connect("timeout", self, "_on_timerdamage_timeout")
		add_child(timer_damage)
		timer_damage.start()
		$effect.play("damage")
		$hud/lifebar.value = life * 3
		if life == 0:
			dying = true
			timer_death= Timer.new()
			timer_death.set_wait_time(3)
			timer_death.connect("timeout", self, "_on_timerdeath_timeout")
			$weapon.visible = false
			add_child(timer_death)
			timer_death.start()
			anim_switch("dead")
			$dying.play()


func _on_timeratt_timeout():
	timer_att.queue_free()
	atacking = false
	$weapon.visible = true

func _on_timerdash_timeout():
	creat_dash_effect()
	timer_dash.queue_free()
	dashing = false

func _on_timerdamage_timeout():
	invinsible = false
	timer_damage.queue_free()
	$effect.play("idle")

func _on_timerdeath_timeout():
	timer_death.queue_free()
	SceneTransition.change_scene("res://scene/game_over.tscn")

func return_position():
	return self.position

func anim_switch(animation):
	var new_anim = str(animation)
	if animation_player.current_animation != new_anim:	
		animation_player.play(new_anim)

func get_direction() -> Vector2:
	return global_position.direction_to(get_global_mouse_position())
	

func creat_dash_effect():
	var player_copy_node = $sprite.duplicate()
	get_parent().add_child(player_copy_node)
	player_copy_node.global_position = global_position

	# Ajuste a modulação para 0.2 no início
	player_copy_node.modulate.a = 0.75
	
	# Crie um Tween para animar a opacidade
	var tween = Tween.new()
	player_copy_node.add_child(tween)
	tween.interpolate_property(player_copy_node, "modulate:a", 0.2, 0, 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

	# Use um Timer para remover o sprite duplicado após a animação
	var removal_timer = Timer.new()
	removal_timer.set_wait_time(0.5)
	removal_timer.connect("timeout", player_copy_node, "queue_free")
	player_copy_node.add_child(removal_timer)
	removal_timer.start()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP and event.is_pressed() and !atacking:
			Events.emit_tutorial_weapon_wheel_opened()
			switch_weapon_up()
			$weapon.play(str(id_weapon))
		elif event.button_index == BUTTON_WHEEL_DOWN and event.is_pressed() and !atacking:
			Events.emit_tutorial_weapon_wheel_opened()
			switch_weapon_down()
			$weapon.play(str(id_weapon))


func _on_weapon_animation_finished():
	if $weapon.animation == "attack_" + str(id_weapon):
		$weapon.play(str(id_weapon))
