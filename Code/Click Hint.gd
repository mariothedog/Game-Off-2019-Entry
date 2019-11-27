extends Node2D

func _ready():
	$Fade.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Fade.start()