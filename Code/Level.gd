extends Node2D

func _ready():
	$Player.map = $TileMap
	modulate.a = 0
	$Transition.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.2,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Transition.start()
	
	$Player.can_low_gravity = true
	$Player.can_double_jump = true

func _draw(): # For debugging
	var mouse_pos = get_global_mouse_position()
	draw_line($Player.position, mouse_pos, Color.red, 2)

func _process(_delta):
	update()
	
	if modulate.a <= 0:
		if get_tree().reload_current_scene() != OK:
			print_debug("An error occured when trying to reload the current scene at Level.gd.")

func _on_Player_jump(duration, jump_dir):
	var multi = 1 + duration/2
	multi = min(multi, 1.4)
	$Player.velocity = jump_dir * $Player.JUMP_SPEED * multi