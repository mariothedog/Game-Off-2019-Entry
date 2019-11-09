extends Node2D

func _ready():
	$Player.map = $TileMap
	modulate.a = 0
	$Transition.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.2,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Transition.start()
	$Player.set_low_gravity_skill(true)

func _draw(): # For debugging
	var mouse_pos = get_global_mouse_position()
	draw_line($Player.position, mouse_pos, Color.red, 2)

func _process(_delta):
	update()

func _on_Player_jump(duration):
	var jump_dir = (get_global_mouse_position() - $Player.position).normalized()
	var multi = 1 + duration/2
	multi = min(multi, 1.4)
	$Player.velocity = jump_dir * $Player.JUMP_SPEED * multi