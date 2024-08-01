extends KinematicBody2D

# Exporta variáveis para ajuste no editor
export (int) var speed: int = 90
export (float) var path_update_interval: float = 0.3
export (float) var direction_threshold: float = 10.0  # Adicione um buffer para evitar inversões rápidas
export (float) var stop_distance: float = 22.0  # Distância mínima para parar antes de colidir com o player
var life = 6
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
var timer_att: Timer
var flip = false

var stat_weapon = [
	{"damage_": 2, "speed_": 10, "lifespan_": 0.3, "dimension_": Vector2(22, 38), "rotate_": true}
]

func _ready():
	$weapon.play("lance")
	id_weapon = 0
	update_path()

func _physics_process(delta):
	if life > 0:
		var dir = get_direction()

		var angle 
		angle =  rad2deg(atan2(dir.y, dir.x))

		$weapon.rotation_degrees = angle 
			
		
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
#	if id_weapon == 2:
#		$weapon.visible = false
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
#	if id_weapon != 2:
#		$weapon.play("attack_" + (str(id_weapon)))

func get_direction() -> Vector2:
	return global_position.direction_to(player.global_position)
