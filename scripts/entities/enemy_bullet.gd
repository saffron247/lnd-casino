class_name EnemyBullet
extends Area2D


const BASE_SPEED = 80
var direction := Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = direction.angle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += direction.normalized() * BASE_SPEED * delta


func _on_body_entered(body):
	if not (body is Enemy):
		queue_free()
