extends Node2D

func _ready():
	$Player.map = $TileMap
	modulate.a = 0
	if global.checkpoint != null:
		$Player.position = global.checkpoint
	
	if global.level > 1:
		global.can_charge = true
	
	$Transition.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.2,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Transition.start()
	global.freezing = false

func _draw(): # For debugging
	var mouse_pos = get_global_mouse_position()
	draw_line($Player.position, mouse_pos, Color.red, 2)

func _process(_delta):
	update()