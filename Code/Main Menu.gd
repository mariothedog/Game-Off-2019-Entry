extends Control

func _on_Play_Button_pressed():
	$Transition.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Transition.start()
	yield($Transition, "tween_completed")
	global.next_level()

func _on_Credits_Button_pressed():
	pass # Replace with function body.

# PLAY BUTTON
func _on_Play_Button_mouse_entered():
	$MarginContainer/VBoxContainer/Play_Button.modulate = Color(0.7, 0.7, 0.7, 1)
	$"Mouse Button Overlap SFX".play()

func _on_Play_Button_mouse_exited():
	$MarginContainer/VBoxContainer/Play_Button.modulate = Color(1, 1, 1, 1)

# CREDITS BUTTON
func _on_Credits_Button_mouse_entered():
	$MarginContainer/VBoxContainer/Credits_Button.modulate = Color(0.7, 0.7, 0.7, 1)
	$"Mouse Button Overlap SFX".play()

func _on_Credits_Button_mouse_exited():
	$MarginContainer/VBoxContainer/Credits_Button.modulate = Color(1, 1, 1, 1)