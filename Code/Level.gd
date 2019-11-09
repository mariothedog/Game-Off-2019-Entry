extends Node2D

func _ready():
	modulate.a = 0
	$Transition.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.4,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Transition.start()
	$Player.set_double_jump_skill(true)

func _draw(): # For debugging
	var mouse_pos = get_global_mouse_position()
	draw_line($Player.position, mouse_pos, Color.red, 2)

func _process(_delta):
	update()

func _on_Player_jump(duration):
	var jump_dir = (get_global_mouse_position() - $Player.position).normalized()
	var multi = 1 + duration/2
	multi = min(multi, 1.4)
	$Player.velocity = jump_dir * $Player.JUMP_SPEED * multi

func _on_Player_health(health):
	if health <=0:
		$Transition.interpolate_property(get_parent(), "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Transition.start()
		$timer_transition_out.start()
	else:
		pass #change the health bar

func _on_timer_transition_out_timeout():
	if get_tree().reload_current_scene() != OK:
		print_debug("An error occured when trying to reload the current scene.")
