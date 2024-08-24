extends Node2D
class_name Pipe



signal died

const height := 1000.0
var was_ever_on_screen := false
@onready var death_clock_timer: Timer = $DeathClockTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	was_ever_on_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if was_ever_on_screen:
		death_clock_timer.start()
	pass # Replace with function body.

func _on_death_clock_timer_timeout() -> void:	
	#Doom Doom Deadoes!! 💀
	died.emit()
	queue_free()
	
