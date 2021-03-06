extends KinematicBody2D

signal jump
signal update_healthbar

var dust_particles = preload("res://Scenes/Dust Particles.tscn")
var jump_trail = preload("res://Scenes/Jump Trail.tscn")

#warning-ignore:unused_class_variable
# JUMP_SPEED is used in Level.gd
export var JUMP_SPEED = 700
export var GRAVITY = Vector2(0, 1300)
export var GROUND_RESISTANCE = 0.11
export var AIR_RESISTANCE = 0.01
export var LOW_GRAVITY = Vector2(0, 400)
export var lives = 3

var hold_duration = 0
var velocity = Vector2()

var hover_shop

# Low Gravity Skill
var can_low_gravity = false

# Double Jump Skill
var can_double_jump = false
var jumps = 0
var can_jump = true # When you auto jump due to the jump bar getting full it starts charging again on the double jump without any player input, this variable stops that

# Wall Grab Skill
var can_wall_grab = false
var stick_to_wall = false
var force_stop_stick = false

# Animation variables
var walk_jumping = false
var is_hurt = false

var dead = false

var map

func update_skill():
	for skill in global.skills:
		if skill == "wall_grab":
			can_wall_grab = true
		elif skill == "double_jump":
			can_double_jump = true
		elif skill == "low_gravity":
			can_low_gravity = true

func _ready():
	global.player = self
	update_skill()

func _physics_process(delta):
	input()
	if not global.freezing:
		movement(delta)
		animate()

func _process(delta):
	if global.freezing:
		hold_duration = 0
		$"Jump Bar".value = 0
	else:
		if dead:
			hold_duration = 0
		else:
			if Input.is_action_pressed("jump"):
				if not hover_shop:
					var not_below = (get_global_mouse_position() - position).normalized().y <= 0.9
					if can_jump and global.can_charge and (not_below or jumps > 0):
						if can_double_jump:
							if (is_on_floor() or jumps < 2):
								hold_duration += delta
						else:
							if is_on_floor() or stick_to_wall:
								hold_duration += delta
					if can_wall_grab and $"Wall Detection".is_colliding() and not force_stop_stick:
						jumps = 0
						can_jump = true
						stick_to_wall = true
					else:
						stick_to_wall = false
		
		$"Jump Bar".value = hold_duration/0.8*100
		if $"Jump Bar".value >= 100:
			jump()

func input():
	if not global.freezing:
		if Input.is_action_just_pressed("take_damage") and global.debug:
			take_damage(1)
		if Input.is_action_just_pressed("add_health") and global.debug:
			add_life(1)
		if Input.is_action_just_pressed("debug"):
			global.debug = not global.debug
	
	if Input.is_action_just_pressed("shop") and (global.level >= 3 or global.debug):
		var shop_node = get_parent().get_node("HUD").get_node("shop")
		if shop_node.visible:
			shop_node.exit()
		else:
			shop_node.visible = true

func _input(event):
	if not global.freezing and event is InputEventMouseButton and not dead:
		if event.button_index == BUTTON_LEFT and not hover_shop:
			if not event.is_pressed() and can_jump:
				if can_double_jump:
					if (is_on_floor() or jumps < 2):
						jump()
				else:
					if is_on_floor() or stick_to_wall:
						jump()
			if event.is_pressed():
				can_jump = true

func jump():
	stick_to_wall = false
	force_stop_stick = true
	$"Force Stop Stick Timer".start()
	
	var multi = 1 + hold_duration/2
	multi = min(multi, 1.4)
	
	var jump_dir = (get_global_mouse_position() - position).normalized()
	if jumps > 0:
		$AnimatedSprite.play("jump")
		walk_jumping = false
		$"Jump SFX".play()
	else:
		if jump_dir.y < -0.2: # So the jump animation doesn't play if the player is "walk-jumping"
			$AnimatedSprite.play("jump")
			walk_jumping = false
			$"Jump SFX".play()
		elif jump_dir.y > 0.9:
			hold_duration = 0
			return
		else:
			walk_jumping = true
			multi /= 1.8
			jump_dir.y -= 0.8
			$AnimatedSprite.play("jump")
	
	emit_signal("jump", multi, jump_dir)
	hold_duration = 0
	jumps += 1
	can_jump = false
	is_hurt = false

func movement(delta):
	if can_low_gravity:
		velocity += LOW_GRAVITY * delta
	else:
		velocity += GRAVITY * delta
	
	if is_on_floor():
		if velocity.y > 0:
			jumps = 0
		
		velocity.x = lerp(velocity.x, 0, GROUND_RESISTANCE)
	else:
		velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE)
	
	if stick_to_wall:
		velocity.y = 0
	
	velocity = move_and_slide(velocity, Vector2.UP)

func animate():
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0
	
	if not dead and not is_hurt:
		if is_on_floor():
			$AnimatedSprite.play("idle")
		else:
			if stick_to_wall:
				$AnimatedSprite.play("wall")
			elif velocity.y >= 0 and not walk_jumping:
				$AnimatedSprite.play("fall")

func take_damage(amount):
	if dead:
		return
	
	lives -= amount
	if lives <= 0:
		dead = true
		$AnimatedSprite.play("die")
	else:
		if is_on_floor():
			is_hurt = true
			$AnimatedSprite.play("hurt")
	
	$"Hurt SFX".play()
	lives = max(0, lives)
	hold_duration = 0
	emit_signal("update_healthbar", -amount)

func add_life(amount):
	if dead:
		return
	
	lives += amount
	
	emit_signal("update_healthbar", amount)

func knockback(amount):
	velocity += amount

func die():
	var transition = get_parent().get_node("Transition")
	transition.interpolate_property(get_parent(), "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.35,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	transition.start()
	dead = true
	yield(transition, "tween_completed")
	if global.checkpoint != null:
		position = global.checkpoint
		dead = false
		add_life(3)
		transition.interpolate_property(get_parent(), "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.35,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		transition.start()
	else:
		if get_tree().reload_current_scene() != OK:
			print_debug("An error occured when trying to reload the current scene at Player.gd in the method \"die\".")

func pickup_coin():
	global.coins += 1
	$"Coin SFX".play()

func _on_Player_jump(_duration, _jump_dir):
	if walk_jumping or not is_on_floor():
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
		
		var d_p = dust_particles.instance()
		d_p.process_material.color = global.tile_colors[tile_below_name].darkened(0.2)
		var pos = map.map_to_world(map_pos_below)
		pos.x = position.x
		d_p.position = pos
		if (get_global_mouse_position()-position).x > 0:
			d_p.rotation_degrees = 0
			d_p.process_material.gravity.y = 20
		else:
			d_p.rotation_degrees = 180
			d_p.process_material.gravity.y = -20
		d_p.emitting = true
		get_parent().add_child(d_p)

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

func _on_Jump_Trail_Cooldown_timeout():
	# Jump Trail Effect
	if not global.freezing and ($AnimatedSprite.animation == "jump" or velocity.length() >= 800) and not walk_jumping and not dead:
		var j_t = jump_trail.instance()
		j_t.position = position
		get_parent().add_child(j_t)

func _on_Force_Stop_Stick_Timer_timeout():
	force_stop_stick = false