extends RigidBody2D
class_name Bird

var button_1_ready_to_fire := true

@onready var button_1_cooloff_timer: Timer = $Button1CooloffTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var button1Pressed = Input.is_action_pressed("Button1")
	if button1Pressed && button_1_ready_to_fire:
		apply_central_impulse(Vector2(0, -1000) )
		button_1_ready_to_fire = false
		button_1_cooloff_timer.start()
	pass


func _on_button_1_cooloff_timer_timeout() -> void:
	button_1_ready_to_fire = true
