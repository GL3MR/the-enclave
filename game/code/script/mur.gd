extends StaticBody2D

export var id = 0  # Exporta a variável id, permitindo que seja configurada no editor
export var type = "open"  # Exporta a variável type com valor padrão "open"
export var nbofmob = 0  # Exporta a variável nbofmob, permitindo que seja configurada no editor

func _ready():
    # Função chamada quando o nó entra na cena
	init()  # Chama a função init

func init():
    # Função de inicialização
	$apparence.play(type)  # Reproduz a animação baseada no tipo
	if type == "open":
		$col.set_deferred("disabled", true)  # Desabilita a colisão se o tipo for "open"

func open():
    # Função para abrir o objeto
	type = "open"  # Define o tipo como "open"
	$apparence.play(type)  # Reproduz a animação baseada no tipo
	$col.set_deferred("disabled", true)  # Desabilita a colisão
