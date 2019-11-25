extends KinematicBody2D

signal hit_player

export var speed = 100
export var gravity = 100
export var impulse = 200

onready var timer = $Timer

var velocity = Vector2()
var can_move = true
 
func _process(delta):
	var collision = move_and_collide(Vector2(speed, gravity) * delta)
	var is_colliding_player  = (collision and collision.collider.name == "Player")
	if can_move:
		velocity += Vector2(speed, gravity) * delta
		velocity = move_and_slide(velocity, Vector2(0, -1))
	if is_on_floor() or is_colliding_player:
		can_move = false
		$Sprite.visible = false
		$Particles2D.emitting  = true	
		if is_colliding_player:
			emit_signal("hit_player")
		if timer.is_stopped():
			timer.start()
			
func shot(dir):
	velocity.y  -= impulse
	speed *= dir
	
func _on_Timer_timeout():
	queue_free() 
