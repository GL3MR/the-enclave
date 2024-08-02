extends KinematicBody2D

# Exporta variáveis para ajuste no editor
export (int) var speed: int = 90
export (float) var path_update_interval: float = 0.3
export (float) var direction_threshold: float = 10.0  # Adicione um buffer para evitar inversões rápidas
export (float) var stop_distance: float = 40.0  # Distância mínima para parar antes de colidir com o player
var life = 50
# Referências de nodos
onready var player_a = get_tree().get_nodes_in_group("hero")
onready var player = player_a[0]
onready var navigation = get_parent().get_node("Navigation2D")
onready var animated_sprite = $AnimatedSprite

onready var dragon = preload("res://scene/dragon.tscn")


# Variáveis internas
var path: PoolVector2Array = PoolVector2Array()
var current_path_index: int = 0
var time_since_last_update: float = 0.0
var low_life_mode = false
var form = 0
var can_transform = false
var transformation = false
var animation = false
var atacking = false
var can_shoot_0 = false
var range_0 = false
var can_shoot_1 = false
var can_shoot_2 = false
var flip = false
var invinsible = false 
var gold = false
var open = true

var min_time_cooldown = 1.5
var max_time_cooldown = 2.5

var min_time_cooldown_1 = 4.5
var max_time_cooldown_1 = 5.5

var min_time_cooldown_2 = 9.5
var max_time_cooldown_2 = 10.5

var teleport_points = [
	Vector2(435, -58),
	Vector2(437, -163),
	Vector2(693, -171),
	Vector2(694, -62)
]

var teleport_points_2 = [
	Vector2(472, -104),
	Vector2(680, -104)
]

var stat_weapon = [
	{"damage_": 5, "speed_": 0, "lifespan_": 1.1, "dimension_": Vector2(65, 32), "rotate_": true, "timestamp_": 0.3},
	{"damage_": 7, "speed_": 600, "lifespan_": 1, "dimension_": Vector2(48, 32), "rotate_": true, "timestamp_": 0.3}
]

func _ready():
	MusicManager.play("Music_Boss")
	$hud/lifebar.value = life * 3  
	$hud/lifebar.visible = false
	$open.start()
	$weapon.visible = false
	$shield_body/shield.visible = false
	$weapon.play("lance")
	update_path()
	
	$TimerCooldown.wait_time = rand_range(min_time_cooldown, max_time_cooldown)
	$TimerCooldown.start()
	
	Events.connect("player_weapon_buster", self, "on_player_weapon_buster")
	Events.connect("dragon_catch_player", self, "on_dragon_catch_player")
	Events.connect("dragon_catch_boss", self, "on_dragon_catch_boss")

func on_dragon_catch_player(body):
	atacking = false
	gold = false
	$shield.visible = false
	
	$TimerCooldown3.wait_time = rand_range(min_time_cooldown_2, max_time_cooldown_2)
	$TimerCooldown3.start()
	$atk_2_acerto.play()
	$atk_2.stop()
	body.hit(10, true)

func on_dragon_catch_boss(body):
	atacking = false
	gold = false
	$shield.visible = false
	
	$TimerCooldown3.wait_time = rand_range(min_time_cooldown_2, max_time_cooldown_2)
	$TimerCooldown3.start()
	$atk_2_acerto.play()
	$atk_2.stop()
	damage(5, true)

func _physics_process(delta):
	if !open:
		$hud/lifebar.value = life * 3
		
		var dir = get_direction()

		var angle 
		angle =  rad2deg(atan2(dir.y, dir.x))

		$weapon.rotation_degrees = angle 

		$shield_body.rotation_degrees = angle 
		
		if can_transform and !transformation and !animation and !gold:
			animated_sprite.flip_h = !animated_sprite.flip_h
			flip = !flip
			animation = true
			form = 1
			$timer_transformation_flash.start()
			$AnimatedSprite.play("Transformation")
			$transform.play()
		elif life > 0 and !atacking and !animation:
			time_since_last_update += delta
			if time_since_last_update >= path_update_interval:
				time_since_last_update = 0.0
				update_path()
			
			if path.size() > 0:
				move_along_path(delta)
			else:
				if animated_sprite.is_playing() and animated_sprite.animation.find("Walk") != -1:
					animated_sprite.stop()
					animated_sprite.play("Idle" + str(form))
					
			if player.life > 0:
				if can_shoot_2:
					attack(2)
				elif can_shoot_1:
					attack(1)
				elif can_shoot_0 and range_0:
					attack(0)
		elif atacking and !gold and !animation:
			if animated_sprite.is_playing() and !animated_sprite.animation.find("Atk") != -1: 
				animated_sprite.play("Atk" + str(form))
		elif life == 0 and !animation: 
			animation = true
			animated_sprite.flip_h = !animated_sprite.flip_h
			flip = !flip
			$weapon.visible = false
			animated_sprite.play("Death")
			$dead.play()
			yield($AnimatedSprite, "animation_finished")
			queue_free()

func update_path():
	# Atualiza o caminho para o jogador
	path = navigation.get_simple_path(global_position, player.global_position)
	current_path_index = 0

func move_along_path(delta):
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player > stop_distance:
		if current_path_index < path.size():
			var target_position = path[current_path_index]
			var direction = (target_position - global_position).normalized()
			var movement = direction * speed * delta
			
			# Move e verifica colisões
			move_and_collide(movement)
			
			# Verifica se atingiu o ponto alvo
			if global_position.distance_to(target_position) < speed * delta:
				current_path_index += 1
			
			# Inverte a animação com base na posição do player, considerando um buffer
			if abs(player.position.x - position.x) > direction_threshold:
				if player.position.x < position.x:
					animated_sprite.flip_h = true
					flip = true
				else:
					animated_sprite.flip_h = false
					flip = false
			
			# Play the walk animation if not already playing
			if not animated_sprite.is_playing() or animated_sprite.animation.find("Walk") == -1:
				$walk.play()
				animated_sprite.play("Walk" + str(form))
		else:
			if animated_sprite.is_playing() and animated_sprite.animation.find("Walk") != -1:
				animated_sprite.stop()
				$walk.stop()
				animated_sprite.play("Idle" + str(form))
	else:
		if animated_sprite.is_playing() and animated_sprite.animation.find("Walk") != -1:
			animated_sprite.stop()
			$walk.stop()
			animated_sprite.play("Idle" + str(form))

func attack(weapon_id: int):

	if weapon_id == 0:
		attack_with_weapon_0()
	elif weapon_id == 1: 
		attack_with_weapon_1()
	elif weapon_id == 2: 
		attack_with_weapon_2()

func attack_with_weapon_0():
	var pack_proj = preload("res://scene/boos_weapon.tscn")
	var inst_proj = pack_proj.instance()
	var stat = stat_weapon[0]
	atacking = true
	can_shoot_0 = false
	$walk.stop()
	animated_sprite.play("Atk" + str(form))
	inst_proj.init(true, stat.damage_, stat.speed_, stat.lifespan_, stat.dimension_, 0, get_direction(), $weapon.global_position, stat.rotate_, flip, stat.timestamp_)
	$atk_0.play()
	get_parent().add_child(inst_proj)
	$TimerAttack.wait_time = stat.lifespan_
	$TimerAttack.start()
	inst_proj.raise()

func attack_with_weapon_1():
	animation = true
	atacking = true
	can_shoot_1 = false
	$walk.stop()
	animated_sprite.play("Teleport")

func attack_with_weapon_2():
	animation = true
	atacking = true
	gold = true
	can_shoot_2 = false
	$walk.stop()
	animated_sprite.play("Teleport")
	
func get_direction() -> Vector2:
	return global_position.direction_to(player.global_position)

func damage(amount, not_invinsible = false):
	if (!invinsible and !gold) or not_invinsible:
		$dano.stop()
		life = max(0, life - amount)
		invinsible = true
		$effect.play("damage")
		
		if life <= 25 and !can_transform:
			can_transform = true 
			atacking = false

func _on_TimerAttack_timeout():
	atacking = false
	$TimerCooldown.wait_time = rand_range(min_time_cooldown, max_time_cooldown)
	$TimerCooldown.start()

func _on_TimerCooldown_timeout():
	can_shoot_0 = true

func _on_TimerAttack2_timeout():
	atacking = false
	$TimerCooldown2.wait_time = rand_range(min_time_cooldown_1, max_time_cooldown_1)
	$TimerCooldown2.start()

func _on_TimerCooldown2_timeout():
	can_shoot_1 = true

func _on_TimerCooldown3_timeout():
	can_shoot_2 = true

func _on_effect_animation_finished(anim_name):
	print(anim_name)
	if anim_name == "damage":
		$effect.play("idle")
		invinsible = false

func _on_timer_timeout():
	var pack_proj = preload("res://scene/boos_weapon.tscn")
	var inst_proj = pack_proj.instance()
	var stat = stat_weapon[1]
	inst_proj.init(true, stat.damage_, stat.speed_, stat.lifespan_, stat.dimension_, 1, get_direction(), $weapon.global_position, stat.rotate_, flip, stat.timestamp_)
	get_parent().add_child(inst_proj)
	$TimerAttack2.wait_time = stat.lifespan_
	$TimerAttack2.start()
	inst_proj.raise()

func _on_weapon_animation_finished():
	if $weapon.playing and $weapon.animation == "lance_1":
		$weapon.visible = false
		$weapon.play("lance")

func on_player_weapon_buster():
	if !gold:
		$shield_body/shield.visible = true
		$shield_body/shield.play("shield")
		$timer_shield.start()

func _on_timer_shield_timeout():
	$shield_body/shield.play("shield_back")
	yield($shield_body/shield, "animation_finished")
	$shield_body/shield.visible = false


func _on_TeleportTimer_timeout():
	print ("TELEPORTTIMER")
	
func teleport_to(new_position: Vector2):
	position = new_position
	
func perform_teleport():
	var random_point = teleport_points[randi() % teleport_points.size()]
	teleport_to(random_point)
	$walk.stop()
	$AnimatedSprite.play("Teleport_Back")

func perform_teleport_2():
	teleport_to(get_farthest_point())
	$walk.stop()
	$AnimatedSprite.play("Teleport_Back")

func get_farthest_point() -> Vector2:
	var farthest_point = teleport_points_2[0]
	var max_distance = player.global_position.distance_to(farthest_point)
	
	for point in teleport_points_2:
		var distance = player.global_position.distance_to(point)
		if distance > max_distance:
			max_distance = distance
			farthest_point = point
	
	return farthest_point

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Transformation":
		animation = false
		transformation = true
		speed = 120
		
		$TimerCooldown2.wait_time = rand_range(min_time_cooldown_1, max_time_cooldown_1)
		$TimerCooldown2.start()
		
		$TimerCooldown3.wait_time = rand_range(min_time_cooldown_2, max_time_cooldown_2)
		$TimerCooldown3.start()
	elif $AnimatedSprite.animation == "Teleport" and !gold:
		perform_teleport()
	elif $AnimatedSprite.animation == "Teleport" and gold:
		perform_teleport_2()
	elif $AnimatedSprite.animation == "Teleport_Back" and !open and !gold:
		animation = false
		var stat = stat_weapon[1]
		$walk.stop()
		animated_sprite.play("Atk" + str(form))
		$weapon.visible = true
		$weapon.play("lance_1")
		$timer.start()
		$atk_1.play()
	elif $AnimatedSprite.animation == "Teleport_Back" and !open and gold:
		animation = false
		# Inverte a animação com base na posição do player, considerando um buffer
		if abs(player.position.x - position.x) > direction_threshold:
			if player.position.x < position.x:
				animated_sprite.flip_h = true
				flip = true
			else:
				animated_sprite.flip_h = false
				flip = false
		$walk.stop()
		animated_sprite.play("shield")
		$timer_gold_flash.start()
		$timer_shield_attack.start()
	elif $AnimatedSprite.animation == "Teleport0" and open:
		$walk.stop()
		animated_sprite.flip_h = false
		animated_sprite.play("Start")
	elif $AnimatedSprite.animation == "Start":
		open = false
		$hud/lifebar.visible = true
		Events.emit_timeline_ended()


func _on_range_body_entered(body):
	if body.is_in_group("hero"):
		range_0 = true;


func _on_range_body_exited(body):
	if body.is_in_group("hero"):
		range_0 = false;


func _on_timer_transformation_flash_timeout():
	Events.emit_flash_screen(Color(0.803922, 0.262745, 0.262745))


func _on_timer_shield_attack_timeout():
	# Inverte a animação com base na posição do player, considerando um buffer
	if abs(player.position.x - position.x) > direction_threshold:
		if player.position.x < position.x:
			animated_sprite.flip_h = true
			flip = true
		else:
			animated_sprite.flip_h = false
			flip = false
	if flip:
		$shield.offset = Vector2(-64, 0)
		$shield.flip_h = true
	$shield.visible = true
	$shield.play("shield")
	$atk_2.play()
	var inst_dragon = dragon.instance()
	get_parent().add_child(inst_dragon)
	inst_dragon.initialize(player, $shield.global_position, flip)

func _on_shield_animation_finished():
	if $shield.animation == "shield":
		$shield.play("shield_loop")


func _on_timer_gold_flash_timeout():
	Events.emit_flash_screen(Color(1, 0.87451, 0.27451))


func _on_open_timeout():
	Events.emit_in_dialog()
	$walk.stop()
	animated_sprite.play("Teleport0")
