extends Control

# Função chamada quando o nó está pronto (inicializado)
func _ready():
	pass # Placeholder, não faz nada. Pode ser usado para inicializar variáveis ou estados.

# Função chamada sempre que um evento de entrada é detectado
func _input(event):
	# Verifica se o evento é de um pressionamento de tecla
	if event is InputEventKey:
		# Verifica se a tecla pressionada é ESCAPE
		if event.scancode == KEY_ESCAPE:
			# Encerra o jogo
			get_tree().quit()
		else:
			# Muda a cena para "Dungeon.tscn"
			var _result = get_tree().change_scene("res://scene/dungeon.tscn")
			_result = null

	# Verifica se o evento é de um botão do joystick
	if event is InputEventJoypadButton:
		# Verifica se o botão pressionado é o botão START
		if event.button_index == JOY_START:
			# Encerra o jogo
			get_tree().quit()
		else:
			# Muda a cena para "Dungeon.tscn"
			var _result = get_tree().change_scene("res://scene/dungeon.tscn")
			_result = null
