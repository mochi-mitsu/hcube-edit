extends Node2D

@export var tileSelect: bool
@export var useObjects: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	#tileSelect = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("l"):
		if tileSelect == false:
			tileSelect = true
		else:
			tileSelect = false

func _input(event):
	if event.is_action_pressed("pause"):
		get_parent().exit()
	if event.is_action_pressed("save"):
		get_node("/root/Main").saveLevel()
		var savediag = AcceptDialog.new()
		add_child(savediag)
		savediag.title = "HyperCube Editor"
		savediag.dialog_text = "Saved!"
		savediag.show()
