extends Node2D

@onready var Main = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	Main.get_child(1).hide() #hide main manu


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
