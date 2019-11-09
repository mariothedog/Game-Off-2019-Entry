extends KinematicBody2D

signal jump

#warning-ignore:unused_class_variable
# JUMP_SPEED is used in Level.gd
export var JUMP_SPEED = 700
export var GRAVITY = Vector2(0, 1300)
export var GROUND_RESISTANCE = 0.11
export var AIR_RESISTANCE = 0.01

var hold_duration = 0
var velocity = Vector2()

var jump_particles = preload("res://Scenes/Jump Particles.tscn")

var map

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

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.is_pressed() and is_on_floor():
			emit_signal("jump", hold_duration)
			hold_duration = 0

func movement(delta):
	velocity += GRAVITY * delta
	
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, GROUND_RESISTANCE)
	else:
		velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func animate():
	pass

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