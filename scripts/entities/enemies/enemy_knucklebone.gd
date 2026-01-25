class_name EnemyKnucklebone
extends Enemy


# PRELOADED SCENES
const BulletScene = preload("res://scenes/entities/enemy_bullet.tscn")


const BASE_SPEED = 80
const SHOOT_THRESHOLD = 25
var stopped = false


func internal_routine():
	if not stopped:
		if (position.distance_to(target.position) <= SHOOT_THRESHOLD):
			velocity = Vector2.ZERO
			stopped = true
			$ShootTimer.start()
		else:
			velocity = position.direction_to(target.position) * BASE_SPEED


func shoot():
	var bullets = []
	for i in range(8):
		var new_bullet = BulletScene.instantiate()
		new_bullet.direction = Vector2.from_angle((PI / 4) * i)
		bullets.append(new_bullet)
	
	for bullet in bullets:
		bullet.position = position + (bullet.direction * 10.0)
		add_sibling(bullet)
	
	stopped = false


func _on_shoot_timer_timeout() -> void:
	shoot()
