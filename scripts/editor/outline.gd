extends ColorRect

@export var currTile: Vector2i = Vector2i(0, 0)
@onready var tiles = get_node("/root/Main/Level/TileMap")
@onready var objects = get_node("/root/Main/Level/ObjectMap")
var select = false
var selectX
var selectY

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("select"):
		select = true
	else:
		select = false
	if get_parent().tileSelect == true:
		self.hide()
	else:
		self.show() 
	self.position.x = (tiles.local_to_map(get_global_mouse_position()).x * 16) 
	self.position.y = (tiles.local_to_map(get_global_mouse_position()).y * 16)


func _input(event):
	if get_parent().tileSelect == true:
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		tiles.erase_cell(0, tiles.local_to_map(self.position))
		objects.erase_cell(0, objects.local_to_map(self.position))
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if get_parent().useObjects == false:
			tiles.set_cell(0, tiles.local_to_map(self.position), 0, currTile)
		else:
			objects.set_cell(0, objects.local_to_map(self.position), 0, currTile)
