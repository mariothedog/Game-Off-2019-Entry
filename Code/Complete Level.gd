extends Area2D

func _on_Complete_Level_body_entered(body):
	if body.name == "Player":
		global.next_level()