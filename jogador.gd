extends Area2D

# Sinal para avisar quando um item foi coletado
signal item_coletado

var is_catching = false

func _ready():
	# Conecta o sinal de colisão
	area_entered.connect(_on_area_entered)
	# Começa o jogo garantindo que só o Idle aparece
	$GloveIdle.show()
	$GloveCatch.hide()
	$GloveIdle.play("idle")

func _process(_delta):
	# Movimento do mouse
	var mouse_x = get_global_mouse_position().x
	global_position.x = mouse_x

	var altura_tela = get_viewport_rect().size.y
	global_position.y = altura_tela - 50

	# Se NÃO estiver pegando, garante que o Idle está rodando
	if not is_catching:
		if not $GloveIdle.visible:
			$GloveIdle.show()
			$GloveCatch.hide()
			$GloveIdle.play("idle")

func play_glove_catch():
	# Se já estiver pegando algo, ignora para não bugar a animação
	if is_catching:
		return

	is_catching = true

	# 1. Troca os Sprites: Esconde a mão aberta, mostra a mão fechada
	$GloveIdle.hide()
	$GloveCatch.show()

	# 2. Toca a animação de pegar (garanta que o LOOP está desligado no editor!)
	$GloveCatch.play("catch")

	# 3. Espera a animação terminar
	await $GloveCatch.animation_finished

	# 4. VOLTA AO NORMAL:
	$GloveCatch.hide() # Esconde a mão fechada
	$GloveIdle.show() # Mostra a mão aberta
	$GloveIdle.play("idle") # Toca o idle

	is_catching = false

func _on_area_entered(area):
	print("Colisão detectada com: " + area.name)
	# Detecta quando um item entra na área do jogador
	if area.name.begins_with("Item") or area.has_method("queue_free"):
		# Verifica se o item já foi coletado
		if area.has_meta("coletado"):
			return
		# Marca como coletado para evitar dupla contagem
		area.set_meta("coletado", true)
		
		print("Item detectado - adicionando ponto")
		# Toca o som ANTES de remover (copia o AudioStream)
		if area.has_node("AudioStreamPlayer") and has_node("AudioStreamPlayer"):
			$AudioStreamPlayer.stream = area.get_node("AudioStreamPlayer").stream
			$AudioStreamPlayer.play()
		# Remove o item IMEDIATAMENTE
		area.queue_free()
		# Atualiza pontuação IMEDIATAMENTE
		get_parent().score += 1
		get_parent().get_node("Placar/Label").text = "Pontos: " + str(get_parent().score)
		print("Pontos atualizados: " + str(get_parent().score))
		# Toca a animação em paralelo
		_start_catch_animation()

func _play_sound_and_remove(area):
	# Esconde o item visualmente
	for child in area.get_children():
		if child is Sprite2D:
			child.hide()
	# Desabilita colisão
	if area.has_node("CollisionShape2D"):
		area.get_node("CollisionShape2D").set_deferred("disabled", true)
	# Toca o som
	if area.has_node("AudioStreamPlayer"):
		area.get_node("AudioStreamPlayer").play()
		await area.get_node("AudioStreamPlayer").finished
	# Remove o item
	area.queue_free()

func _start_catch_animation():
	# Função separada para animação que não bloqueia a pontuação
	if is_catching:
		return
	
	is_catching = true
	$GloveIdle.hide()
	$GloveCatch.show()
	$GloveCatch.play("catch")
	
	# Espera em paralelo sem bloquear
	await $GloveCatch.animation_finished
	
	$GloveCatch.hide()
	$GloveIdle.show()
	$GloveIdle.play("idle")
	is_catching = false