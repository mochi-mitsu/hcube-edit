extends Camera2D

func _input(event):
	if event == InputEventMouseMotion:
		return
	if Input.is_action_pressed("left"):
		self.position.x -= 16
	if Input.is_action_pressed("right"):
		self.position.x += 16
	if Input.is_action_pressed("up"):
		self.position.y -= 16
	if Input.is_action_pressed("down"):
		self.position.y += 16
	if Input.is_action_pressed("zoomin"):
		self.zoom += Vector2(0.5, 0.5)
	if Input.is_action_pressed("zoomout"):
		self.zoom -= Vector2(0.5, 0.5)
