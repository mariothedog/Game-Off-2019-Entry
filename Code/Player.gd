extends KinematicBody2D

const GRAVITY = Vector2(0, 400)

export var SPEED = 300
export var ACCEL = 0.1
export var DEACCEL = 0.9

var velocity = Vector2()
var target_vel = Vector2()

func _physics_process(delta):
	input()
	movement(delta)

func input():
	var input_vel = Vector2()
	
	if Input.is_action_pressed("move_right"):
		input_vel.x += 1
	if Input.is_action_pressed("move_left"):
		input_vel.x -= 1
	
	target_vel = input_vel.normalized() * SPEED

func movement(delta):
	velocity += GRAVITY * delta
	
	if abs(target_vel.x) > abs(velocity.x):
		velocity.x = lerp(velocity.x, target_vel.x, ACCEL)
	else:
		velocity.x = lerp(velocity.x, target_vel.x, DEACCEL)

	print(position)
	move_and_slide(velocity)