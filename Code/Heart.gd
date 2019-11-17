extends Sprite

#warning-ignore:unused_class_variable
var to_be_freed = false

var heart = load("res://Art/UI/Heart.png")
var heart_shatter = load("res://Art/UI/HeartShatter.png")
var heart_appear = load("res://Art/UI/HeartAppear.png")

var current_anim = "idle"

func _ready():
	get_parent().fix_grid()

func play(anim):
	if anim == "heal":
		current_anim = "heal"
		texture = heart_appear
		vframes = 8
		hframes = 8
		frame = 0
		$AnimationPlayer.play("heal")
	else:
		current_anim = "damage"
		texture = heart_shatter
		vframes = 8
		hframes = 8
		frame = 0
		z_index = 1
		$AnimationPlayer.play("damage")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "heal":
		current_anim = "idle"
		texture = heart
		vframes = 1
		hframes = 1
		frame = 0
	else:
		get_parent().fix_grid()
		queue_free()