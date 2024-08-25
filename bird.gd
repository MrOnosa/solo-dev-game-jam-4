extends RigidBody2D
class_name Bird

var global : gm

signal took_damage
signal missile_launched
signal frog_launched
signal collected_ammo
signal collected_frog

var button_1_ready_to_fire := false
var button_2_ready_to_fire := true
var can_be_hurt := true # :'(
var has_frog := false
var has_married_frog := false

@onready var button_1_cooloff_timer: Timer = $Button1CooloffTimer
@onready var button_2_cooloff_timer: Timer = $Button2CooloffTimer
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var snatched_frog: Node2D = $SnatchedFrog
@onready var snatched_frog_sprite: AnimatedSprite2D = $SnatchedFrog/AnimatedSprite2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global = get_node("/root/GM")
	animated_sprite_2d.frame = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	snatched_frog.visible = has_frog
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
		
		if has_frog:
			has_frog = false
			frog_launched.emit(has_married_frog)
			
			
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
	if body is Frog:
		if has_frog == false:
			has_frog = true
			has_married_frog = (body as Frog).married
			snatched_frog_sprite.material.set_shader_parameter("enabled", has_married_frog)
			global.total_frogs_betrothed += 1
			if has_married_frog:
				print_rich("[rainbow]Married frog SNATCHED![/rainbow]")
			else:
				print_rich("[color=green]Frog SNATCHED!")
		body.queue_free()		
	pass # Replace with function body.


func _on_invincibility_timer_timeout() -> void:
	can_be_hurt = true # o.O
