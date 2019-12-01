extends KinematicBody2D

export var speed = 100
export var gravity = 120
export var impulse = 200
export var knockback = 50

onready var timer = $Timer
onready var sprite = $Sprite
onready var particle = $Particles2D

var velocity = Vector2()
var can_move = true
 
func _process(delta):
	if not global.freezing:
		var collision = move_and_collide(Vector2(speed, gravity) * delta)
		if can_move:
			velocity += Vector2(speed, gravity) * delta
			velocity = move_and_slide(velocity, Vector2(0, -1))
		if collision:
			_destroy()

func shot(dir):
	velocity.y -= impulse
	speed *= dir

func _on_Timer_timeout():
	queue_free() 

func _destroy():
	can_move = false
	sprite.visible = false
	particle.emitting  = true
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	if timer.is_stopped():
		timer.start()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		global.player.velocity /= 2
		var dir = (global.player.position - position).normalized()
		global.player.knockback(dir * knockback)
		_destroy()