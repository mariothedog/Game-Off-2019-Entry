extends Area2D

export var DAMAGE = 100

func _on_SpikeTrap_body_entered(body):
	if body.name == "Player":
		damage()
		global.player.velocity /= 4

func damage():
	if not global.player.dead:
		global.player.take_damage(DAMAGE)

func _on_SpikeTrap_body_exited(_body):
	global.player.velocity *= 1.5