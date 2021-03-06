extends Control

func _process(delta):
	if $Label.rect_position.y >= -2300:
		$Label.rect_position.y -= 40 * delta
	else:
		pass

func _on_Mario_pressed():
	var _u = OS.shell_open("https://mariothedog.itch.io")

func _on_vallemrv_pressed():
	var _u = OS.shell_open("https://vallemrv.itch.io/")

func _on_aZamBie_pressed():
	var _u = OS.shell_open("https://sketchyzambie.itch.io")

func _on_gerobakberkah_pressed():
	var _u = OS.shell_open("https://soundcloud.com/akbar-basit")

func _on_bakudas_pressed():
	var _u = OS.shell_open("https://bakudas.itch.io/generic-platformer-pack")

func _on_rvros_pressed():
	var _u = OS.shell_open("https://rvros.itch.io/animated-pixel-hero")

func _on_Puddin_pressed():
	var _u = OS.shell_open("https://opengameart.org/content/rotating-coin")

func _on_kenney_pressed():
	var _u = OS.shell_open("https://kenney.nl")

func _on_shinzohotoroki_pressed():
	var _u = OS.shell_open("https://opengameart.org/content/heart-3")

func _on_DaveB_pressed():
	var _u = OS.shell_open("https://minibobbo.itch.io")

func _on_Iqdev_pressed():
	var _u = OS.shell_open("https://lqdev.itch.io")

func _on_Angelee_pressed():
	var _u = OS.shell_open("https://www.deviantart.com/artsyangelee")

func _on_bevouliin_pressed():
	var _u = OS.shell_open("https://opengameart.org/content/bevouliin-free-game-obstacle-spikes")

func _on_cdrk_pressed():
	var _u = OS.shell_open("https://freesound.org/people/cdrk/sounds/68449")

func _on_Exit_Button_pressed():
	$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	if get_tree().change_scene("res://Scenes/Main Menu.tscn") != OK:
		print_debug("An error occured when trying to switch from the Credits scene to the Main Menu scene.")


func _on_Exit_Button_mouse_entered():
	$"Exit_Button/Button Sprite".modulate = Color(0.7, 0.7, 0.7, 1)

func _on_Exit_Button_mouse_exited():
	$"Exit_Button/Button Sprite".modulate = Color(1, 1, 1, 1)