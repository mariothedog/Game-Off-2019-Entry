extends Particles2D

var jump_texture = load("res://Art/Placeholder/Player/jump/adventurer-jump-00.png")

func _ready():
	var player = get_parent().get_node("Player")
	scale.x = sign(player.velocity.x)
	texture = jump_texture

func _process(_delta):
	modulate.a = lerp(modulate.a, 0, 0.23)
	if modulate.a <= 0.01:
		queue_free()