extends CanvasLayer

var heart = load("res://Scenes/Heart.tscn").instance()

func _ready():
	$"Coin Amount".text = str(global.coins)
	$Level.text = "Level " + str(global.level)
	
	if global.level >= 3:
		$"Shop Button".show()

func _process(_delta):
	$"Coin Amount".text = str(global.coins)
	$Debug.visible = global.debug

func _on_Player_update_healthbar(amount):
	heart = heart.duplicate()
	
	if amount > 0: # Heal
		for _i in range(amount):
			$Lives.add_child(heart)
			heart.play("heal")
			heart = heart.duplicate()
	else: # Damage
		for _i in range(abs(amount)):
			var not_to_be_freed = []
			for child in $Lives.get_children():
				if not child.to_be_freed:
					not_to_be_freed.append(child)
			
			if len(not_to_be_freed) == 0:
				return
			
			var hrt = not_to_be_freed[len(not_to_be_freed)-1]
			
			hrt.to_be_freed = true
			hrt.play("damage")

func _on_Shop_Button_pressed():
	var shop_node = get_parent().get_node("HUD").get_node("shop")
	if shop_node.visible:
		shop_node.exit()
	else:
		shop_node.visible = true

func _on_Shop_Button_mouse_entered():
	global.player.hover_shop = true

func _on_Shop_Button_mouse_exited():
	global.player.hover_shop = false