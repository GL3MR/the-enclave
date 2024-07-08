extends Control

# Função chamada quando o nó é adicionado à cena
func _ready():
	pass # Placeholder para qualquer código a ser executado quando o nó estiver pronto

# Função chamada quando o botão "continue" é pressionado
func _on_continue_pressed():
	# Muda a cena para "Dungeon.tscn"
	get_tree().change_scene("res://scene/dungeon.tscn")

# Função chamada quando o botão "leave" é pressionado
func _on_leave_pressed():
	# Muda a cena para "titlescreen.tscn"
	get_tree().change_scene("res://scene/title_screen.tscn")
