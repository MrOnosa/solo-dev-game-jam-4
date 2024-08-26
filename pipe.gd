extends RigidBody2D
class_name Pipe

signal died

const height := 1000.0
var was_ever_on_screen := false
var hit_by_missile := false
var hit_by_bird := false
var hit_by_anything := false
@onready var death_clock_timer: Timer = $DeathClockTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if rotation_degrees > 90.0:
		rotation_degrees = 90.0
	if rotation_degrees < -90.0:
		rotation_degrees = -90.0

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	was_ever_on_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if was_ever_on_screen:
		death_clock_timer.start()
	pass # Replace with function body.

func _on_death_clock_timer_timeout() -> void:	
	#Doom Doom Deadoes!! 💀
	$AnimationPlayer.play("fade")

func _on_fade_out_complete() -> void:
	died.emit()
	queue_free()	
	
func _on_body_entered(body: Node) -> void:
	if body is Missile || body is Bird || body is Pipe:
		$AnimatedSprite2D.frame = 1
		if !hit_by_anything:
			death_clock_timer.start()
		hit_by_anything = true
