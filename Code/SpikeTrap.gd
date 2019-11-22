extends Area2D

export var DAMAGE = 1
export var GRAVITY = Vector2(0, 1300)
export var KNOCKBACK = Vector2(400, 0)

var velocity = 200

func _on_SpikeTrap_body_entered(body):
	if body.name == "Player":
		body.take_damage(DAMAGE)