extends KinematicBody2D

export var DAMAGE = 10
export var GRAVITY = Vector2(0, 1300)
export var KNOCKBACK = Vector2(400, 0)

var velocity = Vector2()

func _physics_process(delta):
	velocity += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)

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