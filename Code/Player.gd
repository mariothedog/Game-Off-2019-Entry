extends KinematicBody2D

export var SPEED = 400
export var ACCEL = 0.1
export var DEACCEL = 0.7

var velocity = Vector2()
var target_vel = Vector2()

func _physics_process(_delta):
	input()
	movement()

func input():
	var input_vel = Vector2()
	
	if Input.is_action_pressed("move_right"):
		input_vel.x += 1
	if Input.is_action_pressed("move_left"):
		input_vel.x -= 1
	if Input.is_action_pressed("move_up"):
		input_vel.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vel.y += 1
	
	target_vel = input_vel.normalized() * SPEED

func movement():
	if abs(target_vel.x) > abs(velocity.x):
		velocity.x = lerp(velocity.x, target_vel.x, ACCEL)
	else:
		velocity.x = lerp(velocity.x, target_vel.x, DEACCEL)
	
	if abs(target_vel.y) > abs(velocity.y):
		velocity.y = lerp(velocity.y, target_vel.y, ACCEL)
	else:
		velocity.y = lerp(velocity.y, target_vel.y, DEACCEL)
	
	velocity = move_and_slide(velocity)