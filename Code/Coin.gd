extends Area2D
signal pickup_coin

func _ready():
	if connect("pickup_coin", get_parent().get_parent().get_node("Player"), "pickup_coin") != OK:
		print_debug("An error occured when trying to connect the body_entered signal to the Player/pickup_coin method.")

func _on_Coin_body_entered(body):
	if $Sprite.visible and body.name == "Player":
		$Sprite.visible = false
		$coin_particles.emitting = true
		$Timer.start()
		emit_signal("pickup_coin")

func _on_Timer_timeout():
	queue_free()