extends StaticBody2D

# Exporta a variável id para que possa ser definida no editor
export var id = 0

# Obtém todos os nós que estão no grupo "door" na árvore de cena
onready var doors = get_tree().get_nodes_in_group("door")

# Função chamada quando o nó está pronto
func _ready():
	# A função _ready é chamada quando o nó e suas crianças foram adicionados à cena
	pass

# Função para abrir a porta
func open():
	# Toca a animação "on" no nó "apparence"
	$apparence.play("on")
    
	# Para cada porta no grupo "door"
	for door in doors:
		# Se o id da porta for igual ao id deste nó, chama a função open() da porta
		if door.id == id:
			door.open()
