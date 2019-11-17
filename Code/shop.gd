extends Control

var coin_player = null
var item_sel = null

func _ready():
	coin_player = get_node("main_container/container_secondary/container_info/coin_player")
	var conten_item = get_node("main_container/container_secondary/conten_grind/grind_items")
	for item in conten_item.get_children():
		item.connect("on_click", self, "select_item")
		
func select_item(item):
	if item_sel != null:
		item_sel.check.visible = false
	item_sel = item
	item_sel.check.visible = true
	coin_player.select_item(item_sel)
	


func _on_buy_pressed():
	if global.coins - item_sel.price > 0:
		if not (item_sel.skill in global.skills):
			global.skills.append(item_sel.skill)
			global.coins -= item_sel.price
			global.player.update_skill()
			visible = false
	
func _on_exit_pressed():
	visible = false

func _on_shop_visibility_changed():
	global.freezing = visible
	if visible:
		coin_player.update_coins()

	
