extends Node

# Inicializa a variável id_weapon_number com o valor 1
var id_weapon_number = 1

# Função chamada quando o nó é adicionado à cena
func _ready():
	# Define o modo de pausa para processar eventos normalmente mesmo quando o jogo está pausado
	pause_mode = PAUSE_MODE_PROCESS

# Função chamada quando um evento de entrada (input) é detectado
func _input(event):
	# Verifica se o evento é uma tecla pressionada
	if event is InputEventKey:
		# Verifica se a tecla pressionada é a tecla ESCAPE
		if event.scancode == KEY_ESCAPE and event.is_pressed():
			# Chama a função menu
			menu()
	# Verifica se o evento é um botão do joystick pressionado
	if event is InputEventJoypadButton:
		# Verifica se o botão pressionado é o botão START do joystick
		if event.button_index == JOY_START and event.is_pressed():
			# Chama a função menu
			menu()

# Função para exibir ou esconder o menu de pausa
func menu():
	# Verifica se o nó pai possui um nó chamado "pause"
	if get_parent().has_node("pause"):
		# Se possuir, remove o nó "pause" e despausa o jogo
		get_parent().get_node("pause").queue_free()
		get_tree().paused = false
	else:
		# Se não possuir, pausa o jogo
		get_tree().paused = true
		# Carrega a cena "pause.tscn"
		var pack_pause = preload("res://scene/pause.tscn")
		# Cria uma instância da cena "pause.tscn"
		var inst_pause = pack_pause.instance()
		# Adiciona a instância ao nó pai
		get_parent().add_child(inst_pause)
