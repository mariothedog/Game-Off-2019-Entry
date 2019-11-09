extends KinematicBody2D

signal jump

#warning-ignore:unused_class_variable
# JUMP_SPEED is used in Level.gd
export var JUMP_SPEED = 700
export var GRAVITY = Vector2(0, 1300)
export var GROUND_RESISTANCE = 0.11
export var AIR_RESISTANCE = 0.01

var hold_duration = 0
var velocity = Vector2()

func _physics_process(delta):
	movement(delta)
	animate()

func _process(delta):
	if Input.is_action_pressed("jump") and is_on_floor():
		hold_duration += delta
	
	$"Jump Bar".value = hold_duration/0.8*100
	if $"Jump Bar".value >= 100:
		emit_signal("jump", hold_duration)
		hold_duration = 0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.is_pressed() and is_on_floor():
			emit_signal("jump", hold_duration)
			hold_duration = 0

func movement(delta):
	velocity += GRAVITY * delta
	
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, GROUND_RESISTANCE)
	else:
		velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func animate():
	pass

func pickup_coin(body):
	if body.name == "Player":
		global.coins += 1