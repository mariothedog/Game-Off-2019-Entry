extends KinematicBody2D

signal jump

export var SPEED = 400
export var JUMP_SPEED = 800
export var GRAVITY = Vector2(0, 1300)

var velocity = Vector2()

var jump = false

var jump_dir = position
var map

func _physics_process(delta):
	movement(delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed() and is_on_floor():
			emit_signal("jump")

func movement(delta):
	velocity += GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)