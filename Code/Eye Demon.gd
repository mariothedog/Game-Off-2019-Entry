extends KinematicBody2D

export var GRAVITY = Vector2(0, 1300)
export var ACID_DROOL: PackedScene
export var RATIO_SHOT: float = 1
export var MAX_DIST: float = 100

onready var positon_shot = $AnimatedSprite/Position2D
onready var root = get_tree().get_root()
onready var shot_cooldown = $shot_cooldown

var velocity = Vector2()
var can_shot = true

func _ready():
	shot_cooldown.wait_time = RATIO_SHOT

func _physics_process(delta):
	velocity += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	var dist = global.player.position - position
	if can_shot and dist.length() <= MAX_DIST:
		can_shot = false
		var acid = ACID_DROOL.instance()
		acid.global_position = positon_shot.global_position
		acid.shot(-1 if dist.x < 0 else 1)
		$"Acid Throw SFX".play()
		root.add_child(acid)
		shot_cooldown.start()

func _on_Die_body_entered(body):
	if body.name == "Player":
		queue_free()

func _on_shot_cooldown_timeout():
	can_shot = true