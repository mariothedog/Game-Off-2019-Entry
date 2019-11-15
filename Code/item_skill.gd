extends VBoxContainer

export var logo:  Texture = null
export var price: float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	if logo != null:
		$img.texture = logo
	$price.text = str(price)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_item_skill_gui_input(event):
	print(event)
