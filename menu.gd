extends CanvasLayer

signal game_start

@export var amplitude = 8  # Maximum distance from the original position
@export var speed = 10.0  # Speed of the bouncing (adjust as needed)

@onready var arrow: Sprite2D = $Arrow

var start_y_position = 0.0  # Starting Y position
var time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_y_position = arrow.position.y  # Record the initial Y position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	arrow.position.y = start_y_position + amplitude * sin(time * speed)
	var button1Pressed = Input.is_action_pressed("Button1")
	if button1Pressed:
		game_start.emit()
		visible = false
		get_tree().paused = false
	pass
