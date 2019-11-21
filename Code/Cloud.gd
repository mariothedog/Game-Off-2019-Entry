extends Sprite

export var speed_range = [20, 50]

var speed

func _ready():
	texture = load("res://Art/Sky/Clouds/Cloud%s.png" % global.random_int(1, 7))
	speed = global.random_int(speed_range[0], speed_range[1])

func _physics_process(delta):
	position.x += speed * delta
	
	if get_global_transform_with_canvas().origin.x > 2000:#get_viewport().size.x: # Gone past the edge of the screen
		queue_free()