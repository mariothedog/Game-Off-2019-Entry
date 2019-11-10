extends StaticBody2D

export var DAMAGE: int = 10



func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		body.add_damage(DAMAGE)
