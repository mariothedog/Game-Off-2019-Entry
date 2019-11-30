extends Control

func _on_Play_Button_pressed():
	$Transition.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Transition.start()
	yield($Transition, "tween_completed")
	global.next_level()

func _on_Play_Button_mouse_entered():
	$MarginContainer/VBoxContainer/Play.add_color_override("font_color", Color(0.3, 0.3, 0.3))
	$MarginContainer/VBoxContainer/Play.add_color_override("font_color_shadow", Color(0.8, 0.8, 0.8))
	$"Mouse Button Overlap SFX".play()

func _on_Play_Button_mouse_exited():
	$MarginContainer/VBoxContainer/Play.add_color_override("font_color", Color(0, 0, 0))
	$MarginContainer/VBoxContainer/Play.add_color_override("font_color_shadow", Color(0.61, 0.61, 0.61))