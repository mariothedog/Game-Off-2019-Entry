extends Control

var coin_player = null
var item_selected = null

func _ready():
	coin_player = get_node("main_container/container_secondary/container_info/coin_player")
	var content_item = get_node("main_container/container_secondary/content_grind/grind_items")
	for item in content_item.get_children():
		item.connect("on_click", self, "select_item")
		
func select_item(item):
	if item_selected == item:
		item_selected.check.visible = false
		item_selected = null
		coin_player.disable_price_calculator()
	else:
		if item_selected != null:
			item_selected.check.visible = false
		
		item_selected = item
		item_selected.check.visible = true
		coin_player.select_item(item_selected)

func _on_buy_pressed():
	if item_selected != null and global.coins - item_selected.price >= 0:
		if not (item_selected.skill in global.skills):
			global.skills.append(item_selected.skill)
			global.coins -= item_selected.price
			global.player.update_skill()
			visible = false

func _on_exit_pressed():
	exit()

func exit():
	visible = false
	if item_selected != null:
		item_selected.select_background.visible = false
		item_selected.check.visible = false
		item_selected = null

func _on_shop_visibility_changed():
	global.freezing = visible
	if visible:
		coin_player.update_coins()
		global.player.stick_to_wall = false