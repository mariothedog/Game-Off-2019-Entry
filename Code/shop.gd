extends Control


var coin_player = null

func _ready():
	coin_player = get_node("VBoxContainer/HBoxContainer/CenterContainer/coin_player")
	var conten_item = get_node("VBoxContainer/HBoxContainer/grind_items")
	for item in conten_item.get_children():
		item.connect("on_click", coin_player, "select_item")
	

