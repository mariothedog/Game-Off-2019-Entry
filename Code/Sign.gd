extends Area2D

export (String) var text

func _ready():
	$Box.modulate.a = 0
	$Text.modulate.a = 0
	$Text.text = text
	$Text.visible_characters = 0

func _process(_delta):
	$Text.modulate.a = $Box.modulate.a

func _on_Dialogue_node_body_entered(body): # When player touches collision shape, dialogue starts
	if body.get_name() == "Player":
		$Fade.interpolate_property($Box, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Fade.start()
		yield($Fade, "tween_completed")
		$Timer.start()

func _on_Dialogue_node_body_exited(body):
	if body.get_name() == "Player":
		$Fade.interpolate_property($Box, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Fade.start()
		yield($Fade, "tween_completed")
		$Timer.stop()
		$Text.visible_characters = 0

func _on_Timer_timeout():
	$Text.visible_characters += 1
	if $Text.visible_characters >= $Text.get_total_character_count():
		$Timer.stop()