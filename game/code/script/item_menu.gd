extends CanvasLayer

# Obtém todos os nós que estão no grupo "buttonswitch"
onready var buttons = get_tree().get_nodes_in_group("buttonswitch")

# Lista de nomes de armas
var text = ["Sabre", "Blaster", "Plasma", "Mine"]

func _ready():
    # Para cada botão no grupo "buttonswitch"
    for button in buttons:
        # Se o id do botão for maior que o idweaponmax do pai menos 1, torna os filhos do botão invisíveis
        if button.id > get_parent().id_weapon_number - 1:
            for N in button.get_children():
                N.visible = false
        else:
            # Conecta o sinal "pressed" do botão à função "switch" com o id do botão como argumento
            button.connect("pressed", self, "switch", [button.id])

# Função que é chamada quando um botão é pressionado
func switch(id):
    # Define o texto do Label no hudroue de acordo com a arma selecionada
    $hudroue/Label.set_text(text[id])
    # Atualiza o id da arma no pai
    get_parent().id_weapon = id
    # Chama a função apparencehud() no pai
    get_parent().apparence_hud()
    # Verifica e controla a animação atual do hudroue
    if $hudroue/anim.get_current_animation() == "close":
        $hudroue/anim.play("open")
    elif $hudroue/anim.get_current_animation() == "rien":
        $hudroue/anim.play("rien")
    
    # Atualiza o estado pressionado dos botões
    for button in buttons:
        if button.id == id:
            button.pressed = true
        else:
            button.pressed = false

# Função para reproduzir a animação "rien" no hudroue
func rien():
    $hudroue/anim.play("rien")

# Função para reproduzir a animação "close" no hudroue
func close():
    $hudroue/anim.play("close")

# Função para destruir o nó
func destroy():
    queue_free()
