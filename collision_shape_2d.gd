extends CollisionShape2D

var dragging = false

func _input(event):
	# Detecta se o usuário clicou ou tocou no objeto
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			dragging = true
		else:
			dragging = false

func _process(_delta):
	# Se estiver arrastando, a posição do objeto segue o mouse/dedo
	if dragging:
		global_position = get_global_mouse_position()