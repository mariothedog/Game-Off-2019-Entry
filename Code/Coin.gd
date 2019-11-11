extends Area2D

func _ready():
	if connect("body_entered", get_parent().get_parent().get_node("Player"), "pickup_coin") != OK:
		print_debug("An error occured when trying to connect the body_entered signal to the Player/pickup_coin method.")

func _on_Coin_body_entered(_body):
	$Sprite.visible = false
	$coin_particles.emitting = true
	yield(get_tree().create_timer(1),"timeout")
	queue_free()