extends KinematicBody2D

signal jump
signal health #Signal to notify information of status the player

#warning-ignore:unused_class_variable
# JUMP_SPEED is used in Level.gd
export var JUMP_SPEED = 700
export var GRAVITY = Vector2(0, 1300)
export var GROUND_RESISTANCE = 0.11
export var AIR_RESISTANCE = 0.01
export var LOW_GRAVITY = Vector2(0, 400)
export var HEALTH = 100


var hold_duration = 0
var velocity = Vector2()
var is_low_gravity = false
var is_double_jump = true
var gravity_moment = GRAVITY #gravity active
var can_low_gravity = false #only can if skill activate.
var can_double_jump = false #only can if skill activate.
var is_animate = false
var is_hurt = false
var last_jump_dir_x = 0

#All function public to call outside the class

#This func it is called when needed by external passing actions
#For example when the player it falls by precipice
func animate(animation):
	$AnimatedSprite.play(animation)
	
func set_jump_dir(dir):
	if dir.x != last_jump_dir_x:
		$AnimatedSprite.flip_h = dir.x < 0
		last_jump_dir_x = dir.x
	
#Called when it is cath by any enemy.
func add_damage(damage):
	is_animate = true
	HEALTH -= damage
	emit_signal("health", HEALTH)
	if HEALTH <= 0:
		$AnimatedSprite.play("die")
	else:
		is_hurt = true
		$AnimatedSprite.play("hurt")
	
	
#Called when it get health by any provide system health
func add_health(health):
	HEALTH += health
	is_animate = true
	emit_signal("health", HEALTH)
	
#To set low gravity skill outside this class
func set_low_gravity_skill(s):
	can_low_gravity = s

#To set double jamp this class
func set_double_jump_skill(s):
	can_double_jump = s
	
var jump_particles = preload("res://Scenes/Jump Particles.tscn")

var map

func _physics_process(delta):
	movement(delta)
	
func _process(delta):
	if Input.is_action_pressed("jump") and is_on_floor() and HEALTH > 0:
		hold_duration += delta
	
	$"Jump Bar".value = hold_duration/0.8*100
	if $"Jump Bar".value >= 100:
		emit_signal("jump", hold_duration)
		hold_duration = 0
		if is_low_gravity and $timer_low_gravity.is_stopped():
			$timer_low_gravity.start()

func _input(event):
	if event is InputEventMouseButton:
		var button_index = event.button_index == BUTTON_LEFT and HEALTH > 0
		var check_double_jump =  (button_index and not event.is_pressed() and can_double_jump and not is_double_jump)
		if ((button_index and not event.is_pressed() and is_on_floor()) or check_double_jump) and HEALTH > 0:
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
		if HEALTH > 0 and not is_animate:
			$AnimatedSprite.play("idle")
	else:
		velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE)
		if HEALTH > 0 and not is_animate:
			$AnimatedSprite.play("jump")
		
		
		
	
	if is_hurt:
		print(hold_duration)
		is_hurt = false
		if $AnimatedSprite.flip_h:
			velocity.x = 600
		else:
			velocity.x = -600
		
		
	
	velocity = move_and_slide(velocity, Vector2.UP)


#Timeout that controls the low gravity
#This sets the length of time this skill
func _on_low_gravity_timeout():
	gravity_moment = GRAVITY
	is_low_gravity = false

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "die":
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 4
		
	is_animate = false

func pickup_coin(body):
	if body.name == "Player":
		global.coins += 1

func _on_Player_jump(_duration):
	var mouse_pos_offsetted = get_global_mouse_position() - position
	if mouse_pos_offsetted.y > 0:
		return
	
	if map:
		var map_pos_below = map.world_to_map(position)
		map_pos_below.y += 1
		var tile_below = map.get_cellv(map_pos_below)
		
		# If player is standing on the edge of a tile
		if tile_below == -1: # Empty tile
			map_pos_below.x -= 1 # Check tile to the left
			tile_below = map.get_cellv(map_pos_below)
			
			if tile_below == -1:
				map_pos_below.x += 2 # Check tile to the right
				tile_below = map.get_cellv(map_pos_below)
		
		var tile_below_name = map.tile_set.tile_get_name(tile_below)
		
		var j_p = jump_particles.instance()
		j_p.process_material.color = global.tile_colors[tile_below_name].darkened(0.2)
		var pos = map.map_to_world(map_pos_below)
		pos.x = position.x
		j_p.position = pos
		if (get_global_mouse_position()-position).x > 0:
			j_p.rotation_degrees = 0
			j_p.process_material.gravity.y = 20
		else:
			j_p.rotation_degrees = 180
			j_p.process_material.gravity.y = -20
		j_p.emitting = true
		get_parent().add_child(j_p)