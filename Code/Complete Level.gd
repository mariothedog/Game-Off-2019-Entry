extends Area2D

func _on_Complete_Level_body_entered(body):
	if body.name == "Player":
		var transition = get_parent().get_node("Transition")
		transition.interpolate_property(get_parent(), "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		transition.start()
		yield(transition, "tween_completed")
		global.next_level()