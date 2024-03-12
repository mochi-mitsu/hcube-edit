extends Node2D

@onready var outline = get_node("/root/Main/Editor/outline")
@onready var editor = get_node("/root/Main/Editor")
@onready var tileDisplay = $"../currentTile"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if editor.tileSelect == true:
		self.show() 
	else:
		self.hide()
	if $CheckButton.button_pressed == true:
		editor.useObjects = true
		$TileMap.hide()
		$ObjectMap.show()
	else:
		editor.useObjects = false
		$TileMap.show()
		$ObjectMap.hide()
		
			
func _input(event):
	if editor.tileSelect == false:
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if outline != null:
			if editor.useObjects == false:
				outline.currTile = $TileMap.get_cell_atlas_coords(0, $TileMap.local_to_map(get_global_mouse_position() / 2))
			else:
				outline.currTile = $ObjectMap.get_cell_atlas_coords(0, $ObjectMap.local_to_map(get_global_mouse_position() / 2))
			#okay i guess im hardcoding this. trying to make it not hardcoded bugs it to hell
			if editor.useObjects == false:
				tileDisplay.texture = load("res://tiles/tilesets/images/lines.png")
				tileDisplay.hframes = 6
				tileDisplay.vframes = 11
			else:
				tileDisplay.texture = load("res://tiles/objects/1.png")
				tileDisplay.hframes = 5
				tileDisplay.vframes = 4
			tileDisplay.frame_coords = outline.currTile
			if outline.currTile != Vector2i(-1, -1):
				await get_tree().create_timer(0.05).timeout #hack to prevent tile placing on tile select click
				editor.tileSelect = false
