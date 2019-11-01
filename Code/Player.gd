extends KinematicBody2D

export var SPEED = 160
export var ACCEL = 0.1
export var DEACCEL = 0.9

var velocity = Vector2()
var target_vel = Vector2()

func _physics_process(delta):
	input()
	movement()

func input():
	var input_vel = Vector2()
	
	if Input.is_action_pressed("move_right"):
		input_vel.x += 1
	if Input.is_action_pressed("move_left"):
		input_vel.x -= 1
	
	target_vel = input_vel.normalized() * SPEED

func movement():
	if abs(target_vel.x) > abs(velocity.x):
		velocity = lerp(velocity, target_vel, ACCEL)
	else:
		velocity = lerp(velocity, target_vel, DEACCEL)

	print(position)
	move_and_slide(velocity)