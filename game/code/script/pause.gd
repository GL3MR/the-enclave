extends CanvasLayer

# Função chamada quando o nó está pronto (inicializado)
func _ready():
    # Define o foco do teclado no botão 'continue' quando a cena é carregada
	$continue.grab_focus()

# Função chamada quando o botão 'continue' é pressionado
func _on_continue_pressed():
    # Chama a função 'menu' do objeto global
	global.menu()

# Função chamada quando o botão 'relancer' é pressionado
func _on_relancer_pressed():
    # Chama a função 'menu' do objeto global
	global.menu()
    # Muda a cena para "Dungeon.tscn"
	var _result = get_tree().change_scene("res://scene/dungeon.tscn")
	_result = null

# Função chamada quando o botão 'quitter' é pressionado
func _on_quitter_pressed():
    # Chama a função 'menu' do objeto global
	global.menu()
    # Muda a cena para "titlescreen.tscn"
	var _result = get_tree().change_scene("res://scene/title_screen.tscn")
	_result = null
