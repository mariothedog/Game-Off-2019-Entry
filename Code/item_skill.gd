extends Control
signal on_click

export var logo: Texture = null
export var price: int = 0

var node_logo = null
var node_price = null
var particles_item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if logo != null:
		$logo.texture = logo
	$price.text = str(price)
	

func _on_item_skill_mouse_entered():
	$logo/ColorRect.visible = true

func _on_item_skill_mouse_exited():
	$logo/ColorRect.visible = false

func _on_item_skill_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			$particles_items.emitting = true
			emit_signal("on_click", self)


func _on_ColorRect_mouse_entered():
	pass # Replace with function body.


func _on_logo_mouse_entered():
	$logo/ColorRect.visible = true


func _on_logo_mouse_exited():
	$logo/ColorRect.visible = false
