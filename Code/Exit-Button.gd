extends Node2D

func _ready():
	pass

# returns back to Main menu
func _on_Button_pressed():
	$Transition.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Transition.start()
	yield($Transition, "tween_completed")
	global.MainMenu()

func _on_Button_mouse_entered():
	$"Button Sprite".modulate = Color(0.7, 0.7, 0.7, 1)

func _on_Button_mouse_exited():
		$"Button Sprite".modulate = Color(1, 1, 1, 1)
