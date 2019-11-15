extends CanvasLayer

var heart = load("res://Scenes/Heart.tscn").instance()

func _process(_delta):
	$"Coin Amount".text = str(global.coins)

func _on_Player_update_healthbar(amount):
	heart = heart.duplicate()
	
	if amount > 0: # Heal
		for _i in range(amount):
			$Lives.add_child(heart)
			heart.get_child(0).play("heal")
	else: # Damage
		for _i in range(abs(amount)):
			var lives_children = $Lives.get_children()
			var animations_running = 0
			for child in lives_children:
				var plyr = child.get_child(0)
				if plyr.is_playing():
					animations_running += 1
			
			var hrt = lives_children[$Lives.get_child_count()-1-animations_running]
			var anim_player = hrt.get_child(0)
			
			if hrt.to_be_freed: # This prevents a weird bug where it tries to queue_free() the same heart twice. It occurs if you spam damage the player a lot
				$Lives.get_children().back().queue_free()
			
			anim_player.play("damage")