extends CanvasLayer
class_name Victory

var global : gm

var restart_game_allowed := false

@onready var frog_control: Control = $Frog
@onready var bird: AnimatedSprite2D = $Bird

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global = get_node("/root/GM")
	global.frog_marriage_statuses = [1,1,1,1,1]
	global.global_timer = 92.4543
	global.ending_hp = 44
	global.total_missiles_fired = 10
	global.total_frogs_betrothed = 5
	global.total_frogs_widowed = 0
	setup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var button1Pressed = Input.is_action_pressed("Button1")
	var button2Pressed = Input.is_action_pressed("Button2")
	if button1Pressed && button2Pressed && restart_game_allowed:
		global.victory = false
		get_tree().reload_current_scene()	

func setup() -> void:
	$TimeLabel.text = "You completed the game in %s seconds." % str("%.2f" % global.global_timer)
	
	if global.total_missiles_fired == 1:
		$MissilesLabel.text = "1 Missile Launched."
	else:
		$MissilesLabel.text = "%s Missiles Launched." % str("%.0f" % global.total_missiles_fired)
	
	if global.total_frogs_betrothed == 5:
		$FrogsBetrothedLabel.text = "5 Frogs Betrothed. Perfect!" 
	else:
		$FrogsBetrothedLabel.text = "%s Frogs Betrothed." % str("%.0f" % global.total_frogs_betrothed)
	
	$FrogsWidoweed.visible = global.total_frogs_widowed != 0
	if global.total_frogs_widowed == 1:
		$FrogsWidoweed.text = "1 Frog Widowed."
	else:
		$FrogsWidoweed.text = "%s Frogs Widowed. Jeez..." % str("%.0f" % global.total_frogs_widowed)
	
	var frog_sprites = frog_control.get_children()
	var frog_index = 0
	for sprite in frog_sprites:
		(sprite as AnimatedSprite2D).frame = _get_frog_frame(global.frog_marriage_statuses[frog_index])
		sprite.material.set_shader_parameter("enabled", global.frog_marriage_statuses[frog_index] == 2)
		frog_index += 1
	if global.frog_marriage_statuses[1] == 2 && global.frog_marriage_statuses[2] == 2 && global.frog_marriage_statuses[3] == 2 && global.frog_marriage_statuses[4] == 2:
		#Perfect game. HOW!?
		bird.material.set_shader_parameter("enabled", true)
	

func _get_frog_frame(status : int):
	if status == 0:
		#Bachelor
		return 0
	return 1


func _on_can_restart_timer_timeout() -> void:
	restart_game_allowed = true
	$AnimationPlayer.play("mouse")
	pass # Replace with function body.
