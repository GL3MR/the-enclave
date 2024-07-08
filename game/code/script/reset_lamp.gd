# Esta classe herda de Area2D
extends Area2D

# Função chamada quando o nó está pronto
func _ready():
	# Placeholder, atualmente não faz nada
	pass

# Função personalizada chamada test
func test():
	# Lista de referência para comparação
	var true_list = [1, 0, 0, 1, 0, 0]
	
	# Obtém todos os nós no grupo "lampe"
	var lamps = get_tree().get_nodes_in_group("lampe")
	
	# Inicializa uma lista vazia para armazenar o estado atual das lâmpadas
	var current_list = []
	
	# Itera sobre cada lâmpada no grupo
	for lamp in lamps:
		# Verifica se a lâmpada está acesa e adiciona 1 ou 0 à lista corrente
		if lamp.light_on:
			current_list.push_back(1)
		else:
			current_list.push_back(0)
	
	# Imprime a lista atual de estados das lâmpadas
	print("Current list: ", current_list)
	
	# Define um temporizador para desligar as lâmpadas após 10 segundos
	print("Starting timer to turn off lamps in 2 seconds")
	yield(get_tree().create_timer(2.0), "timeout")
	turn_off_lamps(lamps)
	
	# Compara a lista atual com a lista de referência
	if true_list == current_list:
		# Se forem iguais, carrega a cena "switch"
		var pack_switch = preload("res://scene/switch.tscn")
		
		# Instancia a cena "switch"
		var inst_switch = pack_switch.instance()
		
		# Define o ID da instância como 3
		inst_switch.id = 3
		
		# Adiciona a instância como filha deste nó
		add_child(inst_switch)

# Função chamada para desligar as lâmpadas
func turn_off_lamps(lamps):
	# Itera sobre as lâmpadas e as apaga, além de desativá-las
	for lamp in lamps:
		lamp.lightDown()
		lamp.disabled = true

# Função chamada quando um corpo entra em contato com o nó "reset_lamp"
func _on_resetlampe_body_entered(body):
	# Verifica se o corpo pertence ao grupo "hero"
	if body.is_in_group("hero"):
		pass
