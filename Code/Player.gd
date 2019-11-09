extends KinematicBody2D

signal jump

#warning-ignore:unused_class_variable
# JUMP_SPEED is used in Level.gd
export var JUMP_SPEED = 700
export var GRAVITY = Vector2(0, 1300)
export var GROUND_RESISTANCE = 0.11
export var AIR_RESISTANCE = 0.01
export var LOW_GRAVITY = Vector2(0, 400)

var hold_duration = 0
var velocity = Vector2()
var is_low_gravity = false
var is_double_jump = true
var gravity_moment = GRAVITY #gravity active
var can_low_gravity = false #only can if skill activate.
var can_double_jump = false #only can if skill activate.



#to set low gravity skill outside this class
func set_low_gravity_skill(s):
	can_low_gravity = s

#to set double jamp this class
func set_double_jump_skill(s):
	can_double_jump = s
	


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
		if is_low_gravity and $timer_low_gravity.is_stopped():
			$timer_low_gravity.start()

func _input(event):
	if event is InputEventMouseButton:
		var button_index = event.button_index == BUTTON_LEFT
		var check_double_jump =  (button_index and not event.is_pressed() and can_double_jump and not is_double_jump)
		if (button_index and not event.is_pressed() and is_on_floor()) or check_double_jump:
			emit_signal("jump", hold_duration)
			hold_duration = 0
			if not is_double_jump and not is_on_floor():
				is_double_jump = true
			if is_low_gravity and $timer_low_gravity.is_stopped():
				$timer_low_gravity.start()
				
	var pressed = Input.is_action_pressed("low_gravity")
	if pressed and can_low_gravity:
		gravity_moment = LOW_GRAVITY
		is_low_gravity = true
	elif pressed and is_low_gravity:
		#The player can stop its skill
		gravity_moment = GRAVITY
		is_low_gravity = false
		$timer_low_gravity.stop()
		

func movement(delta):
	velocity += gravity_moment * delta
	
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, GROUND_RESISTANCE)
		is_double_jump = false
		$AnimatedSprite.play("idle")
	else:
		velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE)
		$AnimatedSprite.play("jump")
	$AnimatedSprite.flip_h = velocity.x < 0
	
		
		
	
	
	velocity = move_and_slide(velocity, Vector2.UP)

func animate():
	pass
	
#Timeout that controls the low gravity
#This sets the length of time this skill
func _on_low_gravity_timeout():
	gravity_moment = GRAVITY
	is_low_gravity = false


	