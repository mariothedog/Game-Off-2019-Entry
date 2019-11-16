extends Node2D

func _ready():
	set_pos()
	get_tree().get_root().connect("size_changed", self, "set_pos")

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
		child.position.y = 50 * (i / 3) + 40