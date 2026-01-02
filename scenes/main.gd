extends Node2D

# Cena do item que vai cair
@export var item_cena: PackedScene
var score = 0
var vidas = 3

func _ready():
	# Conecta o sinal do jogador para contar pontos
	if has_node("jogador"):
		$jogador.item_coletado.connect(_on_item_coletado)

func _on_timer_timeout():
	var novo_item = item_cena.instantiate()

	# Conecta o sinal de item perdido
	novo_item.connect("item_perdido", _on_item_perdido)

	# Aumenta a velocidade baseada na pontuação (a cada 5 pontos, +20 de velocidade)
	if novo_item.has_method("set") and "velocidade_adicional" in novo_item:
		novo_item.velocidade_adicional = int(score / 5.0) * 20

	# Define o tamanho para 50% do original (porcentagem)
	novo_item.scale = Vector2(0.8, 0.8)

	# Isso pergunta ao Godot: "Qual o tamanho real da tela agora?"
	var largura_tela = get_viewport_rect().size.x

	# Agora ele respeita qualquer tamanho de tela de teste
	var x_aleatorio = randf_range(50, largura_tela - 50)

	novo_item.position = Vector2(x_aleatorio, -50)
	add_child(novo_item)

func adicionar_ponto():
	print("Ponto adicionado!")
	score += 1
	$Placar/Label.text = "Pontos: " + str(score)

func _on_item_coletado():
	# Função chamada quando o jogador coleta um item
	score += 1
	$Placar/Label.text = "Pontos: " + str(score)
	print("Item coletado! Pontos: " + str(score))

func _on_item_perdido():
	# Função chamada quando um item sai da tela
	vidas -= 1
	print("Item perdido! Vidas restantes: " + str(vidas))
	
	if vidas <= 0:
		game_over()

func game_over():
	print("GAME OVER!")
	# Para o timer
	if has_node("Timer"):
		$Timer.stop()
	# Mostra tela de game over (você pode criar uma cena separada)
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	# Por enquanto, reinicia o jogo
	#get_tree().reload_current_scene()
