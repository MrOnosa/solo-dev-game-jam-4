extends Node2D
class_name Game

var global : gm

@export var pipe_scene : PackedScene
@export var missile_scene : PackedScene
@export var ammo_scene : PackedScene
@export var frog_scene : PackedScene
@export var betrothed_frog_scene : PackedScene

var inital_pipe_position : Vector2 = Vector2(600.0, 304.0)
var ammo = 0
var hp = 50
var frog_marriage_statuses : Array[int] # 0 - Bachelor. 1 - Married. 2 - Super Married

@onready var bird: Bird = $Bird
@onready var obstacles: Node2D = $Obstacles
@onready var power_ups: Node2D = $PowerUps
@onready var reference: Node2D = $Reference
@onready var ammo_control: Control = $HUD/Ammo
@onready var frog_control: Control = $HUD/Frog
@onready var pipe_timer: Timer = $PipeTimer
@onready var ammo_timer: Timer = $AmmoTimer
@onready var life_bar: LifeBar = $LifeBar
@onready var menu: CanvasLayer = $Menu
@onready var hud: Control = $HUD


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global = get_node("/root/GM")
	frog_marriage_statuses = [0,0,0,0,0]
	reference.queue_free()
	life_bar.visible = false
	hud.visible = false
	bird.visible = false
	ammo_timer.start(pipe_timer.wait_time + pipe_timer.wait_time/2.0)
	life_bar.paint(hp)
	menu.visible = true
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ammo_textures = ammo_control.get_children()
	var ammo_index = 0
	for texture in ammo_textures:
		texture.visible = (ammo >= ammo_index + 1)
		ammo_index += 1
	
	var frog_sprites = frog_control.get_children()
	var frog_index = 0
	for sprite in frog_sprites:
		(sprite as AnimatedSprite2D).frame = _get_frog_frame(frog_marriage_statuses[frog_index])
		sprite.material.set_shader_parameter("enabled", frog_marriage_statuses[frog_index] == 2)
		frog_index += 1
	
	
	pass
	
func _physics_process(delta: float) -> void:
	for pipe in obstacles.get_children():
		pass
		#pipe.apply_central_force(Vector2(-10000.0, 0.0)*delta)

func _get_frog_frame(status : int):
	if status == 0:
		#Bachelor
		return 0
	return 1
func _on_pipe_died() -> void:
	pass

func _on_pipe_timer_timeout() -> void:	
	var pipeTopXPos = 800.0
	var pipeTopYRangePos = Vector2(-1600, -860)
	var pipeBottomPos = Vector2(500,300)
	
	#Create the top pipe, then use it to decide where the bottom pipe will be	
	var newPipeHigh = pipe_scene.instantiate() as Pipe
	newPipeHigh.position = Vector2(pipeTopXPos, randf_range(pipeTopYRangePos.x, pipeTopYRangePos.y))
	newPipeHigh.died.connect(_on_pipe_died)
	obstacles.add_child(newPipeHigh)
	
	var newPipeLow = pipe_scene.instantiate() as Pipe
	newPipeLow.position = Vector2(newPipeHigh.position.x, newPipeHigh.position.y + newPipeHigh.height + randf_range(200.0, 500.0) )
	while newPipeLow.position.y < -50.0:
		newPipeLow.position.y += 50.0
	newPipeLow.died.connect(_on_pipe_died)
	obstacles.add_child(newPipeLow)


func _on_bird_missile_launched() -> void:
	if ammo > 0:
		global.total_missiles_fired += 1
		ammo -= 1
		var missile = missile_scene.instantiate() as Missile
		missile.position = bird.position
		add_child(missile)

func _on_bird_collected_ammo() -> void:
	ammo += 1
	if ammo > 6:
		ammo = 6

func _on_ammo_timer_timeout() -> void:
	#ammo_timer.start(pipe_timer.wait_time)
	var pipeTopXPos = 800.0
	var pipeTopYRangePos = Vector2(-310, 310)
	#Scaling by 1 increases the bottom y by 50
	
	#Create the top pipe, then use it to decide where the bottom pipe will be	
	var newPipeHigh = ammo_scene.instantiate() as Ammo
	newPipeHigh.position = Vector2(pipeTopXPos, randf_range(pipeTopYRangePos.x, pipeTopYRangePos.y))
	power_ups.add_child(newPipeHigh)


func _on_bird_took_damage() -> void:
	hp -= 1
	life_bar.paint(hp)
	if hp <= 0:
		get_tree().reload_current_scene()
		
	pass # Replace with function body.

func _on_menu_game_start() -> void:	
	life_bar.visible = true
	hud.visible = true
	bird.visible = true
	global.reset()


func _on_frog_timer_timeout() -> void:
	var y_pos = 297
	var x_pos = 800.0
	
	var newFrog = frog_scene.instantiate() as Frog
	newFrog.position = Vector2(x_pos, y_pos)
	newFrog.got_married.connect(_on_frog_married)
	add_child(newFrog)


func _on_bird_frog_launched(frog_already_married : bool) -> void:
	var frog = betrothed_frog_scene.instantiate() as BetrothedFrog
	frog.position = bird.position
	if frog_already_married:
		frog.already_married = true
	add_child(frog)
	pass # Replace with function body.

func _on_frog_married(super_married: bool) -> void:	
	var frog_index = 0
	# Game jam garbage code - look away
	while frog_index < 5:
		if frog_marriage_statuses[frog_index] == 0:
			frog_marriage_statuses[frog_index] = 2 if super_married else 1
			frog_index = 999
		frog_index += 1
	
	if frog_index == 5:
		print_rich("[font-size=32] Victory")
	pass
