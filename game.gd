extends Node2D
class_name Game

@export var pipe : PackedScene
var inital_pipe_position : Vector2 = Vector2(600.0, 304.0)

@onready var bird: Bird = $Bird
@onready var obstacles: Node2D = $Obstacles

@onready var reference: Node2D = $Reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reference.queue_free()
	pass
	#var newPipe = pipe.instantiate() as Pipe
	#newPipe.position = inital_pipe_position
	#newPipe.died.connect(_on_pipe_died)
	#obstacles.add_child(newPipe)
	#
	#var newPipe2 = pipe.instantiate() as Pipe
	#newPipe2.position = inital_pipe_position + Vector2( 300, 100)
	#newPipe2.died.connect(_on_pipe_died)
	#obstacles.add_child(newPipe2)
	#
	#var newPipe3 = pipe.instantiate() as Pipe
	#newPipe3.position = inital_pipe_position + Vector2( 300, 100) + Vector2( 300, -1000)
	#newPipe3.died.connect(_on_pipe_died)
	#obstacles.add_child(newPipe3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	for pipe in obstacles.get_children():
		pipe.apply_central_force(Vector2(-10000.0, 0.0)*delta)
	
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
	#Scaling by 1 increases the bottom y by 50
	
	#Create the top pipe, then use it to decide where the bottom pipe will be	
	var newPipeHigh = pipe.instantiate() as Pipe
	newPipeHigh.position = Vector2(pipeTopXPos, randf_range(pipeTopYRangePos.x, pipeTopYRangePos.y))
	#newPipeHigh.scale.y = 9.0# randf_range(1.0, 9.0)
	newPipeHigh.died.connect(_on_pipe_died)
	obstacles.add_child(newPipeHigh)
	
	var newPipeLow = pipe.instantiate() as Pipe
	newPipeLow.position = Vector2(newPipeHigh.position.x, newPipeHigh.position.y + newPipeHigh.height + randf_range(200.0, 500.0) )
	while newPipeLow.position.y < -50.0:
		newPipeLow.position.y += 50.0
	newPipeLow.died.connect(_on_pipe_died)
	obstacles.add_child(newPipeLow)
	pass # Replace with function body.
