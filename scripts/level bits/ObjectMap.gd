extends TileMap

var obj = null
var levelFinish = preload("res://scenes/level bits/objects/level_finish.tscn")
var spike = preload("res://scenes/level bits/objects/Spike.tscn")
var coin = preload("res://scenes/level bits/objects/coin.tscn")
var player = preload("res://scenes/level bits/player.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	return
	var objects = get_used_cells(0)
	var objRotation = 0
	for i in objects:
		#what object is it
		match(get_cell_atlas_coords(0, i).x):
			0: #level finish bit
				obj = levelFinish.instantiate()
			1: #spikes
				obj = spike.instantiate()
			2: #coins
				obj = coin.instantiate()
			3: #harper
				obj = player.instantiate()
		#what direction should it face
		match(get_cell_atlas_coords(0, i).y):
			0: #up
				objRotation = 0
			1: #down
				objRotation = 180
			2: #left
				objRotation = 270
			3: #right
				objRotation = 90
		add_child(obj) #spawn object
		obj.position = to_global(map_to_local(i)) #set object position
		obj.rotation_degrees = objRotation #set object rotation
		erase_cell(0, i) #erase tile from tilemap cuz object spawned to replace it
	self.set_process(false)
