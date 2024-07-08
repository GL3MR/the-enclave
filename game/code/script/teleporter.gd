extends Area2D

# Exporta a variável new_pos para que possa ser definida no editor
export var new_pos = Vector2(0, 0)

# Declaração das variáveis timerfall e hero
var timer_fall
var hero

# Função chamada quando o nó está pronto
func _ready():
	# A função _ready é chamada quando o nó e suas crianças foram adicionados à cena
	pass

# Função chamada quando um corpo entra na área do teletransportador
func _on_teleporter_body_entered(body):
	if body.is_in_group("hero"):
		# Se o corpo que entrou na área é o herói
		hero = body
		body.set_physics_process(false)  # Desabilita o processamento físico do herói
		body.get_node("AnimatedSprite").play("fall")  # Toca a animação de queda
		timer_fall = Timer.new()  # Cria um novo Timer
		timer_fall.set_wait_time(1)  # Define o tempo de espera do timer
		timer_fall.connect("timeout", self, "_on_timerfall_timeout")  # Conecta o sinal de timeout do timer à função _on_timerfall_timeout
		add_child(timer_fall)  # Adiciona o timer como filho deste nó
		timer_fall.start()  # Inicia o timer
	elif body.is_in_group("mob"):
		# Se o corpo que entrou na área é um mob
		body.queue_free()  # Remove o mob da cena

# Função chamada quando o timer atinge o tempo limite
func _on_timerfall_timeout():
	timer_fall.queue_free()  # Remove o timer da cena
	hero.position = new_pos  # Define a nova posição do herói
	hero.hit(0.5)  # Aplica dano ao herói
	hero.set_physics_process(true)  # Habilita o processamento físico do herói
