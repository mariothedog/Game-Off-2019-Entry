extends Control

func _on_Play_Button_pressed():
	if get_tree().change_scene("res://Scenes/Level 1.tscn") != OK:
		print_debug("An error occured when trying to switch from the Main Menu scene to the level scene.")

func _on_Play_Button_mouse_entered():
	$MarginContainer/VBoxContainer/Play.add_color_override("font_color", Color(0.3, 0.3, 0.3))
	$MarginContainer/VBoxContainer/Play.add_color_override("font_color_shadow", Color(0.8, 0.8, 0.8))

func _on_Play_Button_mouse_exited():
	$MarginContainer/VBoxContainer/Play.add_color_override("font_color", Color(0, 0, 0))
	$MarginContainer/VBoxContainer/Play.add_color_override("font_color_shadow", Color(0.61, 0.61, 0.61))