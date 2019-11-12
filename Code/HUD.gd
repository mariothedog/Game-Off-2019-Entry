extends CanvasLayer

var heart_animation_running = 0

func _process(_delta):
	$"Coin Amount".text = str(global.coins)

func _on_Player_update_healthbar(amount):
	var heart = $Lives.get_child(0).duplicate()
	
	if amount < 0:
		for _i in range(abs(amount)):
			var lives_children = $Lives.get_children()
			var removed_heart = lives_children[len(lives_children)-1-heart_animation_running]
			var anim_player = removed_heart.get_child(0)
			anim_player.play("damage")
			heart_animation_running += 1
			yield(anim_player, "animation_finished")
			print("this delete")
			heart_animation_running -= 1
			removed_heart.queue_free()
	else:
		for _i in range(amount):
			print("add")
			$Lives.add_child(heart)
			var anim_player = heart.get_child(0)
			anim_player.play("heal")