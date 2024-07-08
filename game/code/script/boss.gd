extends KinematicBody2D

# Obtém o primeiro nó no grupo "hero" e atribui a variável player
onready var player_a = get_tree().get_nodes_in_group("hero")
onready var player = player_a[0]

# Inicializa as variáveis de posição do jogador e de vida
var player_pos = Vector2(0, 0)
var life = 10

# Função chamada quando o nó é adicionado à cena
func _ready():
	pass # Placeholder para qualquer código a ser executado quando o nó estiver pronto

# Função chamada a cada frame, delta é o tempo decorrido desde o frame anterior
func _process(delta):
	# Atualiza playerPos com a posição reretornada pela função returnPosition() do nó player
	player_pos = player.returnPosition()

# Função para tocar a animação "attaqueMeteore"
func _attack_meteore():
	$AnimatedSprite.play("attack_meteore")

# Função para reduzir a vida do jogador em 1
func _take_dammage():
	life -= 1
