extends KinematicBody2D

signal jump

export var SPEED = 400
export var JUMP_SPEED = 800
export var GRAVITY = Vector2(0, 1300)
export var GROUND_RESISTANCE = 0.11
export var AIR_RESISTANCE = 0.01

var velocity = Vector2()

func _physics_process(delta):
	movement(delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed() and is_on_floor():
			emit_signal("jump")

func movement(delta):
	velocity += GRAVITY * delta
	
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, GROUND_RESISTANCE)
	else:
		velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE)
	
	velocity = move_and_slide(velocity, Vector2.UP)