extends RigidBody2D
class_name BetrothedFrog

var global : gm

var processed_ever = false
var already_married = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global = get_node("/root/GM")
	animated_sprite_2d.material.set_shader_parameter("enabled", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !processed_ever:
		processed_ever = true
		animated_sprite_2d.material.set_shader_parameter("enabled", already_married)
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if already_married == true:
		global.total_frogs_widowed += 1
	queue_free()
