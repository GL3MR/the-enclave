extends KinematicBody2D

# Exporta variáveis para ajuste no editor
export (int) var speed: int = 110
export (float) var path_update_interval: float = 0.2

# Referências de nodos
onready var player_a = get_tree().get_nodes_in_group("hero")
onready var player = player_a[0]
onready var navigation = get_parent().get_node("Navigation2D")
onready var animated_sprite = $AnimatedSprite

# Variáveis internas
var path: PoolVector2Array = PoolVector2Array()
var current_path_index: int = 0
var time_since_last_update: float = 0.0
var life = 10

func _ready():
	update_path()

func _physics_process(delta):
	time_since_last_update += delta
	if time_since_last_update >= path_update_interval:
		time_since_last_update = 0.0
		update_path()
	
	if path.size() > 0:
		move_along_path(delta)
		$AnimatedSprite.play("Walk")

func update_path():
	# Atualiza o caminho para o jogador
	path = navigation.get_simple_path(global_position, player.global_position)
	current_path_index = 0

func move_along_path(delta):
	if current_path_index < path.size():
		var target_position = path[current_path_index]
		var direction = (target_position - global_position).normalized()
		var movement = direction * speed * delta
		
		# Move e verifica colisões
		movement = move_and_collide(movement)
		
		# Verifica se atingiu o ponto alvo
		if global_position.distance_to(target_position) < speed * delta:
			current_path_index += 1
		
		# Inverte a animação com base na direção
		if direction.x != 0:
			animated_sprite.flip_h = direction.x < 0
