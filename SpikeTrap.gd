extends Area2D

export var DAMAGE = 1
export var KNOCKBACK = Vector2(400, 0)

var can_attack = true

func _on_SpikeTrap_body_entered(body):
	if body.name == "Player" and can_attack and not body.dead:
		damage()

func damage():
	global.player.take_damage(DAMAGE)
	var dir = (global.player.position - position).normalized()
	var kb = KNOCKBACK.rotated(dir.angle())
	global.player.knockback(kb)
	$"Attack Again".start()

func _on_SpikeTrap_body_exited(body):
	$"Attack Again".stop()

func _on_Attack_Again_timeout():
	damage()