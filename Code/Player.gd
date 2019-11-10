extends KinematicBody2D

signal jump
signal update_healthbar

var jump_particles = preload("res://Scenes/Dust Particles.tscn")

#warning-ignore:unused_class_variable
# JUMP_SPEED is used in Level.gd
export var JUMP_SPEED = 700
export var GRAVITY = Vector2(0, 1300)
export var GROUND_RESISTANCE = 0.11
export var AIR_RESISTANCE = 0.01
export var LOW_GRAVITY = Vector2(0, 400)
export var health = 100

var hold_duration = 0
var velocity = Vector2()

# Low Gravity skill
var can_low_gravity = false
var low_gravity_enabled = false

# Double Jump skill
var can_double_jump = false
var jumps = 0
var can_jump = true # When you auto jump due to the jump bar getting full it starts charging again on the double jump without any player input, this variable stops that

# Animation variables
var walk_jumping = false
var is_hurt = false

var dead = false

var map

func _physics_process(delta):
	input()
	movement(delta)
	animate()

func _process(delta):
	if Input.is_action_pressed("jump") and can_jump and not dead:
		if can_double_jump:
			if (is_on_floor() or jumps < 2):
				hold_duration += delta
		else:
			if is_on_floor():
				hold_duration += delta
	
	$"Jump Bar".value = hold_duration/0.8*100
	if $"Jump Bar".value >= 100:
		jump()

func input():
	if can_low_gravity:
		if Input.is_action_just_pressed("low_gravity"):
			low_gravity_enabled = true
			if $"Low Gravity Timer".is_stopped():
				$"Low Gravity Timer".start()
			else:
				low_gravity_enabled = false
				$"Low Gravity Timer".stop()
	if Input.is_action_just_pressed("take_damage"):
		take_damage(10)
	if Input.is_action_just_pressed("add_health"):
		add_health(10)

func _input(event):
	if event is InputEventMouseButton and not dead:
		if event.button_index == BUTTON_LEFT:
			if not event.is_pressed() and can_jump:
				if can_double_jump:
					if (is_on_floor() or jumps < 2):
						jump()
				else:
					if is_on_floor():
						jump()
			if event.is_pressed():
				can_jump = true

func jump():
	var jump_dir = (get_global_mouse_position() - position).normalized()
	emit_signal("jump", hold_duration, jump_dir)
	hold_duration = 0
	jumps += 1
	can_jump = false
	if jump_dir.y < -0.2: # So the jump animation doesn't play if the player is "walk-jumping"
		$AnimatedSprite.play("jump")
		walk_jumping = false
	else:
		walk_jumping = true
	is_hurt = false

func movement(delta):
	if low_gravity_enabled:
		velocity += LOW_GRAVITY * delta
	else:
		velocity += GRAVITY * delta
	
	if is_on_floor():
		if velocity.y > 0:
			jumps = 0
		
		velocity.x = lerp(velocity.x, 0, GROUND_RESISTANCE)
	else:
		velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func animate():
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0
	
	if not dead and not is_hurt:
		if is_on_floor():
			$AnimatedSprite.play("idle")
		else:
			if velocity.y >= 0 and not walk_jumping:
				$AnimatedSprite.play("fall")

func take_damage(amount):
	health -= amount
	if health <= 0:
		dead = true
		$AnimatedSprite.play("die")
	else:
		if is_on_floor():
			is_hurt = true
			$AnimatedSprite.play("hurt")
	
	emit_signal("update_healthbar", health, "dmg")

func add_health(amount):
	health += amount
	health = min(100, health) # So the player can't get more than 100 health
	
	emit_signal("update_healthbar", health, "heal")

func knockback(amount):
	velocity += amount

func die():
	var transition = get_parent().get_node("Transition")
	transition.interpolate_property(get_parent(), "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.35,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	transition.start()
	dead = true

func pickup_coin(body):
	if body.name == "Player":
		global.coins += 1

func _on_Player_jump(_duration, _jump_dir):
	var mouse_pos_offsetted = get_global_mouse_position() - position
	if mouse_pos_offsetted.y > 0 or not is_on_floor():
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
			
			if tile_below == -1:
				return
		
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

func _on_Low_Gravity_Timer_timeout():
	low_gravity_enabled = false

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "jump": # So the jump animation doesn't loop
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 1
	elif $AnimatedSprite.animation == "hurt":
		is_hurt = false
	elif $AnimatedSprite.animation == "die":
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 4
		die()