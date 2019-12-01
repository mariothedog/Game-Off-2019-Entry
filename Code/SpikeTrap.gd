extends Area2D

func _on_SpikeTrap_body_entered(body):
	if body.name == "Player":
		damage()
		global.player.velocity /= 4

func damage():
	if not global.player.dead:
		global.player.take_damage(global.player.lives)

func _on_SpikeTrap_body_exited(_body):
	global.player.velocity *= 1.5