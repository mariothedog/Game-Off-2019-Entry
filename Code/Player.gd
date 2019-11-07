extends KinematicBody2D

export var SPEED = 400
export var ACCEL = 0.1
export var DEACCEL = 0.7
export var JUMP_SPEED = 600
export var GRAVITY = Vector2(0, 1300)

var velocity = Vector2()

var jump = false

var jump_dir = position
var map

func _draw():
	var pos = get_global_mouse_position()
	draw_line(Vector2(position.x, position.y + 32), Vector2(pos.x, pos.y+32), Color.red, 2)

func _physics_process(delta):
	update()
	movement(delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed() and is_on_floor():
			jump_dir = get_global_mouse_position()#.normalized() # This is relative to the center unlike event position
			#velocity = dir * JUMP_SPEED

func movement(delta):
	velocity += GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)