extends TextureRect

var to_be_freed = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "damage":
		queue_free()

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "damage":
		to_be_freed = true