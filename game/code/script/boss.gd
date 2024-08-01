extends KinematicBody2D

# Exporta variáveis para ajuste no editor
export (int) var speed: int = 90
export (float) var path_update_interval: float = 0.3
export (float) var direction_threshold: float = 10.0  # Adicione um buffer para evitar inversões rápidas
export (float) var stop_distance: float = 22.0  # Distância mínima para parar antes de colidir com o player
var life = 50
# Referências de nodos
onready var player_a = get_tree().get_nodes_in_group("hero")
onready var player = player_a[0]
onready var navigation = get_parent().get_node("Navigation2D")
onready var animated_sprite = $AnimatedSprite

# Variáveis internas
var path: PoolVector2Array = PoolVector2Array()
var current_path_index: int = 0
var time_since_last_update: float = 0.0

var id_weapon
var atacking = false
var can_shoot = false
var flip = false
var invinsible = false 

var min_time_cooldown = 1.5
var max_time_cooldown = 2.5

var stat_weapon = [
	{"damage_": 5, "speed_": 0, "lifespan_": 1.1, "dimension_": Vector2(65, 43), "rotate_": true, "timestamp_": 0.3},
	{"damage_": 5, "speed_": 200, "lifespan_": 1, "dimension_": Vector2(32, 32), "rotate_": true, "timestamp_": 0.3}
]

func _ready():
	$hud/lifebar.value = life * 3  
	$weapon.visible = false
	$shield_body/shield.visible = false
	$weapon.play("lance")
	id_weapon = 1
	update_path()
	
	$TimerCooldown.wait_time = rand_range(min_time_cooldown, max_time_cooldown)
	$TimerCooldown.start()
	
	Events.connect("player_weapon_buster", self, "on_player_weapon_buster")

func _physics_process(delta):
	$hud/lifebar.value = life * 3
	var dir = get_direction()

	var angle 
	angle =  rad2deg(atan2(dir.y, dir.x))

	$weapon.rotation_degrees = angle 

	$shield_body.rotation_degrees = angle 
	
	if life > 0 and !atacking:
			
		
		time_since_last_update += delta
		if time_since_last_update >= path_update_interval:
			time_since_last_update = 0.0
			update_path()
		
		if path.size() > 0:
			move_along_path(delta)
		else:
			if animated_sprite.is_playing() and animated_sprite.animation == "Walk":
				animated_sprite.stop()
				animated_sprite.play("Idle")
		
		if can_shoot:
			attack()
	elif atacking:
		if animated_sprite.is_playing() and !animated_sprite.animation == "Atk": 
			animated_sprite.play("Atk")
	else: 
		$weapon.visible = false
		animated_sprite.play("Death")
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
			if not animated_sprite.is_playing() or animated_sprite.animation != "Walk":
				animated_sprite.play("Walk")
		else:
			if animated_sprite.is_playing() and animated_sprite.animation == "Walk":
				animated_sprite.stop()
				animated_sprite.play("Idle")
	else:
		if animated_sprite.is_playing() and animated_sprite.animation == "Walk":
			animated_sprite.stop()
			animated_sprite.play("Idle")

func attack():
	var pack_proj = preload("res://scene/boos_weapon.tscn")
	var inst_proj = pack_proj.instance()
	var stat = stat_weapon[id_weapon]
	atacking = true
	can_shoot = false
#	if id_weapon == 2:
#		$weapon.visible = false
	if id_weapon == 0:
		animated_sprite.play("Atk")
		inst_proj.init(true, stat.damage_, stat.speed_, stat.lifespan_, stat.dimension_, id_weapon, get_direction(), $weapon.global_position, stat.rotate_, flip, stat.timestamp_)
		get_parent().add_child(inst_proj)
		$TimerAttack.wait_time = stat.lifespan_
		$TimerAttack.start()
		inst_proj.raise()
	elif id_weapon == 1:
		animated_sprite.play("Atk")
		$weapon.visible = true
		$weapon.play("lance_1")
		$timer.start()
		
#	if id_weapon != 2:
#		$weapon.play("attack_" + (str(id_weapon)))

func get_direction() -> Vector2:
	return global_position.direction_to(player.global_position)

func damage(amount):
	if !invinsible:
		life = max(0, life - amount)
		invinsible = true
		$effect.play("damage")

func _on_TimerCooldown_timeout():
	can_shoot = true

func _on_TimerAttack_timeout():
	atacking = false
	$TimerCooldown.wait_time = rand_range(min_time_cooldown, max_time_cooldown)
	$TimerCooldown.start()

func _on_effect_animation_finished(anim_name):
	print(anim_name)
	if anim_name == "damage":
		$effect.play("idle")
		invinsible = false

func _on_timer_timeout():
	var pack_proj = preload("res://scene/boos_weapon.tscn")
	var inst_proj = pack_proj.instance()
	var stat = stat_weapon[id_weapon]
	inst_proj.init(true, stat.damage_, stat.speed_, stat.lifespan_, stat.dimension_, id_weapon, get_direction(), $weapon.global_position, stat.rotate_, flip, stat.timestamp_)
	get_parent().add_child(inst_proj)
	$TimerAttack.wait_time = stat.lifespan_
	$TimerAttack.start()
	inst_proj.raise()


func _on_weapon_animation_finished():
	if $weapon.playing and $weapon.animation == "lance_1":
		$weapon.visible = false
		$weapon.play("lance")

func on_player_weapon_buster():
	$shield_body/shield.visible = true
	$shield_body/shield.play("shield")
	$timer_shield.start()

func _on_timer_shield_timeout():
	$shield_body/shield.play("shield_back")
	yield($shield_body/shield, "animation_finished")
	$shield_body/shield.visible = false
