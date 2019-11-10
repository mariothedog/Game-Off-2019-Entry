<<<<<<< Updated upstream
extends CanvasLayer

func _process(_delta):
	$"Coin Amount".text = str(global.coins)

func _on_Player_update_healthbar(value, type):
	$"Health Bar/Tween".interpolate_property($"Health Bar",
	"value", $"Health Bar".value, value,
	0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$"Health Bar/Tween".start()
=======
extends CanvasLayer
>>>>>>> Stashed changes
