extends KinematicBody2D

export var DAMAGE = 1
export var GRAVITY = Vector2(0, 1300)
export var KNOCKBACK = Vector2(400, 0)
export var ACID_DROOL: PackedScene
export var RATIO_SHOT: float = 1

onready var ray_right = $AnimatedSprite/right
onready var ray_left = $AnimatedSprite/left
onready var positon_shot = $AnimatedSprite/Position2D
onready var root = get_tree().get_root()

var velocity = Vector2()
var can_shot = true

func _physics_process(delta):
	velocity += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if can_shot and (ray_left.is_colliding() or ray_right.is_colliding()):
		can_shot = false
		var acid = ACID_DROOL.instance()
		acid.global_position = positon_shot.global_position
		acid.shot(-1 if ray_left.is_colliding() else 1)
		root.add_child(acid)
		yield(get_tree().create_timer(RATIO_SHOT), "timeout")
		can_shot = true

func _on_Attack_body_entered(body):
	if body.name == "Player":
		body.take_damage(DAMAGE)
		var dir = (body.position - position).normalized()
		var kb = KNOCKBACK.rotated(dir.angle())
		body.knockback(kb)
		$Attack/CollisionShape2D.set_deferred("disabled", true)
		$"Attack Cooldown".start()

func _on_Attack_Cooldown_timeout():
	$Attack/CollisionShape2D.set_deferred("disabled", false)