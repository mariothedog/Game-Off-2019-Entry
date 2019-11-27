extends Area2D

func _on_Checkpoint_body_entered(body):
	if body.name == "Player":
		if global.checkpoint != null:
			if body.position.x <= global.checkpoint.x:
				return
		var pos = position
		pos.y -= 28 # So the player doesn't spawn in the ground
		global.checkpoint = pos