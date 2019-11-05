extends CanvasLayer

var npcs = [
	["Alice", 5], # Affection level out of 10
	["Ben", 3],
	["Charlie", 7],
	["Daniel", 9],
	["Erin", 0],
	["Freya", 10]
	] # Will be removed once there are actual NPCs

func _ready():
	update_affection() # Will be called by a signal in the future

func update_affection():
	var npc_affection_node = $"Affection Background/NPC".duplicate()
	#print(npc_affection_node.get_child_count())
	$"Affection Background/NPC".queue_free()
	
	npcs.sort_custom(self, "sort_second_descending")
	for npc in npcs:
		var name = npc[0]
		var value = npc[1]
		var portrait = load("res://Art/Placeholder/UI/%s.png" % name.to_lower())
		
		npc_affection_node.rect_position.y += 75
		npc_affection_node.texture = portrait
		
		var heart = TextureRect.new()
		heart.texture = load("res://Art/Placeholder/UI/Affection Meter.png")
		heart.rect_position = Vector2(20, 15)
		for i in range(value):
			heart.rect_position.x += 50
			npc_affection_node.add_child(heart)
			heart = heart.duplicate()
		
		$"Affection Background".add_child(npc_affection_node)
		npc_affection_node = npc_affection_node.duplicate()
		for child in npc_affection_node.get_children(): # So it doesn't keep the hearts from the previous npc
			child.queue_free()

func sort_second_descending(a, b):
	return a[1] > b[1]

func _on_Affection_Button_pressed():
	$"Affection Background".visible = not $"Affection Background".visible

func _on_Exit_Button_pressed():
	$"Affection Background".hide()