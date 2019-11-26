extends Node2D

func _ready():
	$Player.map = $TileMap
	$Player.can_charge = false
	modulate.a = 0
	$Transition.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.2,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Transition.start()
	global.freezing = false
	
	
	$"Click Hint/Fade".interpolate_property($"Click Hint", "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$"Click Hint/Fade".start()
	

func _draw(): # For debugging
	var mouse_pos = get_global_mouse_position()
	draw_line($Player.position, mouse_pos, Color.red, 2)

func _process(_delta):
	update()
	
	if modulate.a <= 0:
		if get_tree().reload_current_scene() != OK:
			print_debug("An error occured when trying to reload the current scene at Level.gd.")

func _on_Player_jump(jump_multi, jump_dir):
	if $"Click Hint".modulate.a > 0:
		$"Click Hint/Fade".stop_all()
		$"Click Hint/Fade".interpolate_property($"Click Hint", "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$"Click Hint/Fade".start()
	$Player.velocity = jump_dir * $Player.JUMP_SPEED * jump_multi