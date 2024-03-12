extends Node2D

@export var gameVersion: String = "HyperCube Editor 0.0.2 (0.0.8)"
@export var savePath: String

# Called when the node enters the scene tree for the first time.
func _ready():
	
	loadMenu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loadMenu():
	var mainMenu = load("res://scenes/menus/mainMenu.tscn").instantiate()
	call_deferred("add_child", mainMenu)

func startLevel(level):
	loadScene(level)
	loadScene("res://scenes/editor.tscn")
	while $"Level/ObjectMap" == null:
		await get_tree().create_timer(0.01).timeout
	$"Level/ObjectMap".set_process(false)
	$mainMenu.queue_free()
	$"HUD".show()

func loadScene(scene):
	var newScene = load(scene).instantiate()
	call_deferred("add_child", newScene)

func exit():
	if get_node("/root/Main/Level") != null: #the node always exists when exit() is called
											 #but theres a crash if i dont check first
		get_node("/root/Main/Level").queue_free()
	if get_node("/root/Main/Editor") != null: #the node always exists when exit() is called
											 #but theres a crash if i dont check first
		get_node("/root/Main/Editor").queue_free()
	$HUD.hide()
	loadMenu()

func saveLevel():
	for child in $Level.get_children():
		child.set_owner($Level)
	
	var savedLevel = PackedScene.new()
	savedLevel.pack($Level)
	ResourceSaver.save(savedLevel, savePath)

func reload(node):
	var filename = get_node(node).get_scene_file_path()
	get_node(node).free()
	startLevel(filename)
