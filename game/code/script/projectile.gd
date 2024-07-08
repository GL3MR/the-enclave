extends KinematicBody2D

var allie_ = false  # Define se a entidade é uma aliada
var damage_ = 1  # Dano causado pela entidade
var speed_ = 100  # Velocidade de movimento da entidade
var tde_life = 1  # Tempo de vida da entidade
var dir = Vector2(0, 0)  # Direção do movimento
var id  # Identificador de aparência
var timer_life  # Timer para controlar o tempo de vida

func _ready():
    # Função chamada quando o nó entra na cena
    timer_life = Timer.new()  # Cria um novo Timer
    timer_life.set_wait_time(tde_life)  # Define o tempo de espera do Timer
    timer_life.connect("timeout", self, "_on_timerlife_timeout")  # Conecta o sinal timeout do Timer a uma função
    add_child(timer_life)  # Adiciona o Timer como filho deste nó
    timer_life.start()  # Inicia o Timer

func init(allie_, damage_, speed_, tde_life, dimension, apparence, dir, pos, rot):
    # Função de inicialização com parâmetros
    z_index = -1  # Define a ordem de renderização
    self.allie_ = allie_  # Define se é aliado
    self.damage_ = damage_  # Define o dano
    self.speed_ = speed_  # Define a velocidade
    self.tde_life = tde_life  # Define o tempo de vida
    self.dir = dir  # Define a direção
    self.id = apparence  # Define a aparência
    var angle  # Variável para calcular o ângulo de rotação
    angle = -abs(dir.y) * 90 * (dir.y + 2) + abs(dir.x) * 90 * (dir.x + 3)  # Calcula o ângulo com base na direção
    self.position = pos  # Define a posição
    self.position += dir * dimension.x * 2  # Ajusta a posição com base na direção e dimensão
    if rot:
        rotation_degrees = angle  # Define a rotação se rot é verdadeiro
    $apparence.play("weapon" + str(apparence))  # Reproduz a animação baseada na aparência
    $area / col.shape.extents = dimension  # Ajusta a extensão da forma de colisão

func _physics_process(delta):
    # Função chamada a cada frame de física
    move_and_slide(dir * speed_)  # Move a entidade com deslizamento

func _on_timerlife_timeout():
    # Função chamada quando o Timer expira
    destroy()  # Chama a função destroy

func destroy():
    # Função para destruir a entidade
    queue_free()  # Libera a entidade da memória

func _on_area_body_entered(body):
	# Função chamada quando um corpo entra na área de colisão
	if body is StaticBody2D:
		speed_ = 0  # Para a velocidade se colidir com um StaticBody2D
	if body is TileMap:
		speed_ = 0  # Para a velocidade se colidir com um TileMap
	if body.is_in_group("boss") and allie_:
		body.life -= 1  # Diminui a vida do boss se for aliado
	if body.is_in_group("switch") and (id == 0 or id == 1 or id == 5):
		body.open()  # Abre o switch se o id for 0, 1 ou 5
	if body.is_in_group("lampe") and (id == 2):
		body.lightUp()  # Acende a lâmpada se o id for 2
	if body.is_in_group("mob") and allie_:
		body.damage(damage_)  # Aplica dano ao mob se for aliado
		queue_free()  # Libera a entidade após causar dano
	if body.is_in_group("hero") and not allie_:
		body.hit(damage_)  # Aplica dano ao herói se não for aliado
