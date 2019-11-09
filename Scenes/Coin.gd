extends Area2D

func _ready():
	connect("body_entered", get_parent().get_parent().get_node("Player"), "pickup_coin")

func _on_Coin_body_entered(_body):
	queue_free()