extends RigidBody2D
class_name Frog

var global : gm

signal got_married

var married := false
var starting_linear_velocity

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var honeymoon_timer: Timer = $HoneymoonTimer
@onready var bonus_timer: Timer = $BonusTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global = get_node("/root/GM")
	starting_linear_velocity = linear_velocity	
	if animated_sprite_2d.material is ShaderMaterial:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body is BetrothedFrog:
		# 💚💚💚
		global.total_frogs_married += 1
		if (body as BetrothedFrog).already_married == true:
			global.total_frogs_super_married += 1
			animated_sprite_2d.material.set_shader_parameter("enabled", true)
			print_rich("[rainbow]Super Married Complete!!![/rainbow]")
		else:
			print_rich("[color=green]Marriage Complete")
		animation_player.play("blush")
		married = true
		honeymoon_timer.start()
		body.queue_free() # It is unclear what happens to the frog we launched
		got_married.emit((body as BetrothedFrog).already_married)


func _on_honeymoon_timer_timeout() -> void:
	if linear_velocity.x < 0.0:
		print_rich("[color=green] Bonus time starting")
		# This is so hard to do, give them a bit more time
		bonus_timer.start()
	else:
		# Destroy the married frog	
		queue_free()


func _on_bonus_timer_timeout() -> void:
	# Destroy the married frog anyway
	queue_free()
