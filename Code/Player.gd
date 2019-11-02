extends KinematicBody2D

const GRAVITY = Vector2(0, 1300)

export var SPEED = 300
export var ACCEL = 0.1
export var DEACCEL = 0.9
export var JUMP_SPEED = 500

var velocity = Vector2()
var target_vel = Vector2()

var jump = false

func _physics_process(delta):
	input()
	movement(delta)

func input():
	var input_vel = Vector2()
	
	if Input.is_action_pressed("move_right"):
		input_vel.x += 1
	if Input.is_action_pressed("move_left"):
		input_vel.x -= 1
	
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true
	
	target_vel = input_vel.normalized() * SPEED

func movement(delta):
	velocity += GRAVITY * delta
	
	if abs(target_vel.x) > abs(velocity.x):
		velocity.x = lerp(velocity.x, target_vel.x, ACCEL)
	else:
		velocity.x = lerp(velocity.x, target_vel.x, DEACCEL)

	if jump and is_on_floor():
		velocity.y = -JUMP_SPEED
	
	velocity = move_and_slide(velocity, Vector2.UP)