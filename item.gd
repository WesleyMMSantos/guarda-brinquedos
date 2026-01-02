extends Area2D

# Sinal para avisar quando o item sai da tela
signal item_perdido

@export var velocidade = 150
var velocidade_adicional = 0

func _process(delta):
	position.y += (velocidade + velocidade_adicional) * delta
	$ToyFallingAnimation.show()
	$ToyFallingAnimation.play("falling")

	# PEGA A ALTURA DA TELA AUTOMATICAMENTE
	var altura_da_tela = get_viewport_rect().size.y

	# Só desaparece se passar totalmente do fundo da tela (altura + 100 de margem)
	if position.y > altura_da_tela + 100:
		# Emite sinal de item perdido
		item_perdido.emit()
		queue_free()

func _on_area_entered(area):
	if area.name == "jogador":
		# peça para o jogador tocar a animação
		if area.has_method("play_glove_catch"):
			area.play_glove_catch()

		# Oculta o item
		for filho in get_children():
			if filho is Sprite2D:
				filho.hide()

		$CollisionShape2D.set_deferred("disabled", true)

		if has_node("AudioStreamPlayer"):
			$AudioStreamPlayer.play()
			await $AudioStreamPlayer.finished

		get_parent().adicionar_ponto()
		queue_free()
