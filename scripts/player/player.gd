extends CharacterBody2D

# mess with these 4 consts till it feels right
#4, huh?
var gravity = 850
var xspeed = 5
var jumpHeight = 6
var diveSpeed = 170
var diveHeight = 200
var diveFallSpeed = 2
var wallJumpHeight = 7
var xMovement = true
var yMovement = true
var diving = false
var justJumped = false
var dead = false
@onready var Main = get_node("/root/Main")
@onready var HUDanimator = get_node("/root/Main/HUD/ColorRect/AnimationPlayer")
@onready var playerSprite = $Sprite

func onWall():
	if ($RayCast2DL.is_colliding() 
	or $RayCast2DL2.is_colliding()
	or $RayCast2DL3.is_colliding()):
		return "left"
	elif ($RayCast2DR.is_colliding()
	or $RayCast2DR2.is_colliding()
	or $RayCast2DR3.is_colliding()):
		return "right"
	else:
		return "none"

func _ready():
	get_node("/root/Main/Level/ScreenCamera").target = get_path()
	HUDanimator.play("fadeIn")


func killPlayer(): #rip harper
	dead = true
	#if not $SoundPlayers/dead.playing:
		#$SoundPlayers/dead.play() ive lost the sound file
	HUDanimator.play("flash")
	if playerSprite.direction == "right":
		$Sprite.play("dead")
	else:
		$Sprite.flip_h = true #flip death sprite if facing left
		$Sprite.play("dead")
	await get_tree().create_timer(1).timeout
	HUDanimator.play("fadeOut")
	await get_tree().create_timer(0.5).timeout
	Main.reload(get_parent().get_parent().get_path())


func _input(event):
	if dead:
		return

#walljump
	if event.is_action_pressed("jump") == true and (onWall() != "none") and not is_on_floor():
		xMovement = false
		velocity.y = -wallJumpHeight / get_physics_process_delta_time()
		if onWall() == "left":
			velocity.x = xspeed / get_physics_process_delta_time()
			$AnimationPlayer.play("wall_jump_right")
		else: 
			velocity.x = -xspeed / get_physics_process_delta_time()
			$AnimationPlayer.play("wall_jump_left")
		await get_tree().create_timer(0.18).timeout
		xMovement = true

#jump
	if event.is_action_pressed("jump") and is_on_floor() == true:
		velocity.y = -jumpHeight / get_physics_process_delta_time()
		$AnimationPlayer.play("jump")
		justJumped = true

#dive
	if (event.is_action_pressed("action") and is_on_floor() == false
	and diving == false and velocity.x != 0):
		if onWall() == "none":
			diving = true
			velocity.y = 0
			velocity.y = -diveHeight
			if playerSprite.direction == "right":
				velocity.x += diveSpeed
			else:
				velocity.x += -diveSpeed
			$AnimationPlayer.play("dive")
			xMovement = false
			await get_tree().create_timer(0.25).timeout
			xMovement = true
			
		else:
			xMovement = false
			velocity.y = -diveHeight
			if onWall() == "left":
				velocity.x = diveSpeed
			else: 
				velocity.x = -diveSpeed
			await get_tree().create_timer(0.18).timeout
			xMovement = true

#pause/exit
	if event.is_action_pressed("pause"):
		Main.exit()

#debug input
	if event.is_action_pressed("debugKey"):
		var HUD = load("res://scenes/hud.tscn")
		Main.call_deferred("add_child", HUD)

func _physics_process(delta):
	if dead:
		return

#dive reset
	if is_on_floor() or onWall() != "none":
		diving = false


#ceiling hit
	if self.position.y - 16 == $"../../ScreenCamera".limit_top:
		velocity.y = 20


#horizontal movement
	if xMovement == true:
		if Input.is_action_pressed("ui_left"):
			if velocity.x > 0:
				velocity.x = 0
			velocity.x = -xspeed / delta
		elif Input.is_action_pressed("ui_right"):
			if velocity.x < 0:
				velocity.x = 0
			velocity.x = xspeed / delta
		elif diving == false:
			velocity.x = 0

#apply gravity
	velocity.y += delta * gravity
	if velocity.y > 600:
		velocity.y = gravity
	move_and_slide()
	#clamping instead of hiding a tile out of bounds means you cant walljump off the level bounds
	self.position.x = clamp(self.position.x, $"../../ScreenCamera".limit_left + 16, $"../../ScreenCamera".limit_right - 16)
	self.position.y = clamp(self.position.y, $"../../ScreenCamera".limit_top + 16, $"../../ScreenCamera".limit_bottom - 16)


