extends VBoxContainer
var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$price_item.visible = false
	$rest.visible = false
	$HSeparator.visible = false
	$price.text = str(global.coins)
	coins = global.coins


func select_item(item):
	$price_item.visible = true
	$price_item.text = str(item.price)
	$HSeparator.visible = true
	$rest.visible = true
	$rest.text = str(coins - item.price)


func _on_item_skill_mouse_entered():
	pass # Replace with function body.


func _on_item_skill_mouse_exited():
	pass # Replace with function body.
