extends Node2D

func _ready():
	set_pos()
	if get_tree().get_root().connect("size_changed", self, "set_pos") != OK:
		print_debug("An error occured while trying to connect the Lives node in HUD.tscn to the size_changed signal in the viewport.")

func set_pos():
	position.x = get_viewport_rect().size.x

func fix_grid():
	var idle_children = []
	for child in get_children():
		if child.current_anim != "damage":
			idle_children.append(child)
	
	for i in range(len(idle_children)):
		var child = idle_children[i]
		child.position.x = -55 * (i % 3) - 40
		child.position.y = 50 * floor(i / 3.0) + 40