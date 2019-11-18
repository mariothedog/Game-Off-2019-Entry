extends Control

signal on_click

#warning-ignore-all:unused_class_variable

export var logo: Texture = null # Icon shown in the shop
export var price: int = 0 # Price of the skill
export var skill: String = "" # Var name skill in the player script
export var description: String = "" # Description to show the name, duration, etc.

onready var check = get_node("check")
onready var select_background = get_node("logo/ColorRect")

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
		if event.button_index == BUTTON_LEFT and event.pressed:
			$particles_items.emitting = true
			emit_signal("on_click", self)