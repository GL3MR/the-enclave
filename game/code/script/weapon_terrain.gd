extends Area2D

# Exporta a variável id para que ela possa ser editada no editor do Godot
export var id = 0

# Função chamada quando o nó é adicionado à cena
func _ready():
	# Verifica se id é maior ou igual ao valor máximo de id de arma global
	if id >= global.id_weapon_number:
		# Toca a animação "weapon" correspondente ao id
		$apparence.play("weapon" + str(id))
	else:
		# Remove o nó da cena se id for menor que o valor máximo de id de arma global
		queue_free()

# Função chamada quando um corpo entra na área deste nó
func _on_weapon_terrain_body_entered(body):
	# Verifica se o corpo está no grupo "hero"
	if body.is_in_group("hero"):
		# Aumenta o valor máximo de id de arma do corpo (jogador)
		body.id_weapon_number = id + 1
		# Atualiza o valor máximo de id de arma global
		global.id_weapon_number = id + 1
		# Remove o nó da cena
		queue_free()
		# Se o id for igual a 3, muda a cena para "credit.tscn"
		if id == 3:
			get_tree().change_scene("res://Scene/credit.tscn")
