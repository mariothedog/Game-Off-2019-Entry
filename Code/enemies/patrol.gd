extends KinematicBody2D

enum TYPE_PATROL {BLUE, RED, GREEN}

export (TYPE_PATROL) var type = TYPE_PATROL.BLUE
export var speed: int = 100
export var damage: int = 1
export var KNOCKBACK = Vector2(400, 0)

onready var animation = $AnimatedSprite
onready var cliff_detected = $AnimatedSprite/RayCast2D

var _gravity = 300
var _speed_moment = speed
var _velocity = Vector2()

func _ready():
	set_physics_process(false)
	if type == TYPE_PATROL.BLUE:
		_speed_moment = speed
		animation.play("blue")
	elif type == TYPE_PATROL.GREEN:
		_speed_moment = speed * 1.2
		animation.speed_scale = 1.2
		animation.play("green")
	elif type == TYPE_PATROL.RED:
		_speed_moment = speed * 1.6
		animation.speed_scale = 1.6
		animation.play("red")
	_velocity.x += _speed_moment

func _physics_process(delta):
	if not global.freezing:
		if (is_on_wall() or not cliff_detected.is_colliding()):
			_velocity.x *= -1
			scale.x *= -1
		
		_velocity.y += _gravity * delta
		_velocity.y = move_and_slide(_velocity, Vector2.UP).y

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		_velocity.x *= -1
		scale.x *= -1
		if not global.player.dead:
			global.player.take_damage(damage)
			var dir = (body.position - position).normalized()
			var kb = KNOCKBACK.rotated(dir.angle())
			body.knockback(kb)