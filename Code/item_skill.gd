extends Control
signal on_click

export var logo: Texture = null #Icon is show in shop
export var price: int = 0 #price the skill
export var skill: String = "" #Var name skill in the player script
export var description: String = "" #Description show the name, keep time, etc.

onready var check = get_node("check")

var node_logo = null
var node_price = null
var particles_item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if logo != null:
		$logo.texture = logo
	$price.text = str(price)
	$logo/ColorRect/Label.text = description
	

func _on_item_skill_mouse_entered():
	$logo/ColorRect.visible = true

func _on_item_skill_mouse_exited():
	$logo/ColorRect.visible = false

func _on_item_skill_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			$particles_items.emitting = true
			emit_signal("on_click", self)

