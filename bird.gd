extends RigidBody2D
class_name Bird

signal took_damage
signal missile_launched
signal collected_ammo

var button_1_ready_to_fire := true
var button_2_ready_to_fire := true
var can_be_hurt := true # :'(

@onready var button_1_cooloff_timer: Timer = $Button1CooloffTimer
@onready var button_2_cooloff_timer: Timer = $Button2CooloffTimer
@onready var invincibility_timer: Timer = $InvincibilityTimer

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.frame = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var button1Pressed = Input.is_action_pressed("Button1")
	if button1Pressed && button_1_ready_to_fire:
		# Flap time
		apply_central_impulse(Vector2(0, -750) )
		animated_sprite_2d.frame = 1
		button_1_ready_to_fire = false
		button_1_cooloff_timer.start()
	var button2Pressed = Input.is_action_pressed("Button2")
	if button2Pressed && button_2_ready_to_fire:
		# Missile time! pew pew
		missile_launched.emit()
		button_2_ready_to_fire = false
		button_2_cooloff_timer.start()
	pass

func _on_button_1_cooloff_timer_timeout() -> void:
	animated_sprite_2d.frame = 0
	button_1_ready_to_fire = true

func _on_button_2_cooloff_timer_timeout() -> void:
	button_2_ready_to_fire = true

func _on_body_entered(body: Node) -> void:
	if body is Pipe:
		if can_be_hurt:
			invincibility_timer.start()
			can_be_hurt = false # 😊
			took_damage.emit()
	if body is Ammo:
		print_rich("[color=grey]Ammo GET!")
		collected_ammo.emit()
		body.queue_free()		
	pass # Replace with function body.


func _on_invincibility_timer_timeout() -> void:
	can_be_hurt = true # o.O
