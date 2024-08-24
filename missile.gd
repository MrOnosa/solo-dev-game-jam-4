extends RigidBody2D
class_name Missile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	apply_central_force(Vector2(200000.0, 0.0)*delta)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
