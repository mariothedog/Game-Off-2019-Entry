extends Node2D

func _ready():
	$Player.map = $TileMap

func _draw(): # For debugging
	var mouse_pos = get_global_mouse_position()
	draw_line($Player.position, mouse_pos, Color.red, 2)

func _process(_delta):
	update()

func _on_Player_jump():
	var jump_dir = get_global_mouse_position().normalized()
	$Player.velocity = jump_dir * $Player.JUMP_SPEED