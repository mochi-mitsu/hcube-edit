extends AnimatedSprite2D

var direction = "right"
var velx = 0
var vely = 0

func _process(delta):
	if animation == "dead":
		return
	velx = get_parent().velocity.x
	vely = get_parent().velocity.y
	
	if velx < 0:
			direction = "left"
	elif velx > 0:
			direction = "right"

	match(direction):
		"left":
			if vely < 0:
				animation = "upLeft"
			elif vely > 0:
				animation = "downLeft"
			else:
				animation = "left"
		"right":
			if vely < 0:
				animation = "upRight"
			elif vely > 0:
				animation = "downRight"
			else:
				animation = "right"
