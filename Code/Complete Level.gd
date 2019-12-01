extends Area2D

func _on_Complete_Level_body_entered(body):
	if body.name == "Player":
		# Freeze the player
		global.player.velocity = Vector2(0, 0)
		global.player.GRAVITY = Vector2(0, 0)
		global.player.LOW_GRAVITY = Vector2(0, 0)
		
		if global.level == 5:
			global.credits()
			global.level = 0
			global.coins = 0
			global.skills = []
			global.can_charge = false
			global.checkpoint = null
		else:
			global.next_level()