extends "res://Code/Level.gd"

func _on_Player_jump(jump_multi, jump_dir):
	$Player.velocity = jump_dir * $Player.JUMP_SPEED * jump_multi