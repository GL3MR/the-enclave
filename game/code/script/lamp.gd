extends StaticBody2D

# Exporta a variável id para que possa ser definida no editor
export var id = 0

# Declaração das variáveis allumer e disabled
var light_on = false
var disabled = false

# Função chamada quando o nó está pronto
func _ready():
    # A função _ready é chamada quando o nó e suas crianças foram adicionados à cena
    pass

# Função para acender a luz
func lightUp():
    if not disabled:
        # Toca a animação "allumé" no nó AnimatedSprite
        $AnimatedSprite.play("allumé")
        # Habilita o nó Light2D
        $Light2D.enabled = true
        # Define allumer como true
        light_on = true
        # Obtém todos os nós no grupo "testlampe"
        var test = get_tree().get_nodes_in_group("testlampe")
        # Chama a função test() no primeiro nó do grupo
        test[0].test()

# Função para apagar a luz
func lightDown():
    # Toca a animação "éteint" no nó AnimatedSprite
    $AnimatedSprite.play("éteint")
    # Desabilita o nó Light2D
    $Light2D.enabled = false
    # Define allumer como false
    light_on = false
