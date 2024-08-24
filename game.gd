extends Node2D
class_name Game

@export var pipe_scene : PackedScene
@export var missile_scene : PackedScene
@export var ammo_scene : PackedScene
var inital_pipe_position : Vector2 = Vector2(600.0, 304.0)
var ammo = 3
var hp = 5

@onready var bird: Bird = $Bird
@onready var obstacles: Node2D = $Obstacles
@onready var power_ups: Node2D = $PowerUps
@onready var reference: Node2D = $Reference
@onready var ammo_control: Control = $HUD/Ammo
@onready var pipe_timer: Timer = $PipeTimer
@onready var ammo_timer: Timer = $AmmoTimer
@onready var life_bar: LifeBar = $LifeBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reference.queue_free()
	ammo_timer.start(pipe_timer.wait_time + pipe_timer.wait_time/2.0)
	life_bar.paint(hp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ammo_textures = ammo_control.get_children()
	var ammo_index = 0
	for texture in ammo_textures:
		texture.visible = (ammo >= ammo_index + 1)
		ammo_index += 1
	
	pass
	
func _physics_process(delta: float) -> void:
	for pipe in obstacles.get_children():
		pass
		#pipe.apply_central_force(Vector2(-10000.0, 0.0)*delta)
	
func _on_pipe_died() -> void:
	pass
	#var newPipe = pipe.instantiate()
	#newPipe.position = inital_pipe_position
	#newPipe.died.connect(_on_pipe_died)
	#obstacles.add_child(newPipe)


#func _on_bird_body_entered(body: Node) -> void:
	#if body is Pipe:
		#bird.any_collision_occured = true
		#print_rich("[color=red]Ouch!")
	#pass # Replace with function body.


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
	pass # Replace with function body.
