extends CanvasLayer

func _process(_delta):
	$"Coin Amount".text = str(global.coins)

func _on_Player_update_healthbar(value, type):
	var heart = $Lives.get_child(0).duplicate()
	
	for child in $Lives.get_children(): # Removes all hearts
		child.queue_free()
	
	for i in range(value):
		$Lives.add_child(heart)
		heart = $Lives.get_child(0).duplicate() # So the heart's positions change