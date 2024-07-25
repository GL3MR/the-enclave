extends KinematicBody2D

onready var animation_player = $anim
var can_pick = true
var target_rotation = 0
var target_rotation_current = 0

var life: int
var max_life = 25
var timer = null 
var speed = 100  
var dash_speed = 200 
var invinsible = false 

var flip = true

var stat_weapon = [
	{"damage_": 1, "speed_": 0, "lifespan_": 0.4, "dimension_": Vector2(14, 22), "rotate_": true}, 
	{"damage_": 1, "speed_": 400, "lifespan_": 1, "dimension_": Vector2(4, 4), "rotate_": true}, 
	{"damage_": 3, "speed_": 0, "lifespan_": 0.4, "dimension_": Vector2(16, 10), "rotate_": true}
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

func _ready():
	life = max_life
	$hud/lifebar.value = life * 3  

func _physics_process(delta):
	$hud/lifebar.value = life * 3
	
	var dir = get_direction()
	
	var angle 
	angle =  rad2deg(atan2(dir.y, dir.x))
	
	$weapon.play(str(id_weapon))

	if(id_weapon == 1 or id_weapon == 2):
		$weapon.rotation_degrees = angle + 90
		$weapon.position.y = 8
	else:
		$weapon.rotation_degrees = angle

	if not dashing and not atacking and not dying:
		true_direction = Vector2.ZERO

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
				
				if(id_weapon == 1 or id_weapon == 2):
					$weapon.position.x = -4
				else:
					$weapon.position.x = -6
				
				flip = false
			else:
				$shadow.position.x = 0
				
				if(id_weapon == 1 or id_weapon == 2):
					$weapon.position.x = 4
				else:
					$weapon.position.x = 6
				
				
				flip = true

		if true_direction != Vector2.ZERO:
			direction = true_direction

		if Input.is_action_just_pressed("switch"):
			switch()

		if Input.is_action_just_pressed("Special"):
			if action == 1:
				dash()

		if Input.is_action_just_pressed("attaque") and not has_node("InGameMenu"):
			attack()

	elif dashing:
		move_and_slide(direction * dash_speed)

func switch():
	id_weapon = (id_weapon + 1) % id_weapon_number
	if not has_node("InGameMenu"):
		var pack_menu = preload("res://scene/item_menu.tscn")
		var inst_menu = pack_menu.instance()
		add_child(inst_menu)
		inst_menu.switch(id_weapon)
	else:
		$InGameMenu.switch(id_weapon)
	apparence_hud()

func apparence_hud():
	$hud/weapon_switch.set_texture(load(path_weapon[id_weapon]))

func dash():
	dashing = true
	timer_dash = Timer.new()
	timer_dash.set_wait_time(0.2)
	timer_dash.connect("timeout", self, "_on_timerdash_timeout")
	add_child(timer_dash)
	timer_dash.start()
	anim_switch("dash")
	if true_direction == Vector2.ZERO:
		true_direction = direction
	direction = true_direction 

func attack():
	atacking = true
	$weapon.visible = false
	timer_att = Timer.new()
	timer_att.set_wait_time(0.4)
	timer_att.connect("timeout", self, "_on_timeratt_timeout")
	add_child(timer_att)
	timer_att.start()
	var pack_proj = preload("res://scene/projectile.tscn")
	var inst_proj = pack_proj.instance()
	var stat = stat_weapon[id_weapon]
	inst_proj.init(true, stat.damage_, stat.speed_, stat.lifespan_, stat.dimension_, id_weapon, get_direction(), position, stat.rotate_, flip)
	get_parent().add_child(inst_proj)
	inst_proj.raise()

func hit(dmg):
	if not invinsible:
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
			timer_death.set_wait_time(1)
			timer_death.connect("timeout", self, "_on_timerdeath_timeout")
			add_child(timer_death)
			timer_death.start()
			anim_switch("dead")


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
	get_tree().change_scene("res://scene/game_over.tscn")

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
