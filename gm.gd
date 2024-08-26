extends Node
class_name gm

# Frogs picked up
var total_frogs_betrothed := 0

# Frogs married
var total_frogs_married := 0

# A married frog gets picked up and lands on another frog
var total_frogs_super_married := 0

# A married frog gets picked up and doesn't land on another frog
var total_frogs_widowed := 0

# missiles fired
var total_missiles_fired := 0

var frog_marriage_statuses : Array[int] # 0 - Bachelor. 1 - Married. 2 - Super Married

var global_timer := 0.0
var ending_hp := 0
var victory := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset() -> void:
	total_frogs_betrothed = 0
	total_frogs_married = 0
	total_frogs_super_married = 0
	total_frogs_widowed = 0
	total_missiles_fired = 0
	frog_marriage_statuses = [0,0,0,0,0]
	global_timer = 0.0
	victory = false
