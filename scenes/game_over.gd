extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _ready():
	# Adiciona elementos da UI aqui no Godot:
	# - Label com "GAME OVER"
	# - Button "Jogar Novamente"
	# - Button "Sair"
	pass

func _on_jogar_novamente_pressed():
	# Volta para a cena principal
	get_tree().change_scene_to_file("res://node_2d.tscn")

func _on_sair_pressed():
	# Fecha o jogo
	get_tree().quit()