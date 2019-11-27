extends "res://Code/Level.gd"

func _on_Player_jump(jump_multi, jump_dir):
	if $"Click Hint".modulate.a > 0:
		$"Click Hint/Fade".stop_all()
		$"Click Hint/Fade".interpolate_property($"Click Hint", "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$"Click Hint/Fade".start()
	$Player.velocity = jump_dir * $Player.JUMP_SPEED * jump_multi

func _on_Unlock_Jump_Charging_body_entered(body):
	if body.name == "Player":
		global.can_charge = true