class_name EnemyKnucklebone
extends Enemy


const BASE_SPEED = 80
const SHOOT_THRESHOLD = 25
var stopped = false


func internal_routine():
	if not stopped:
		set_movement_target(target.global_position)
		var next_path_position = $NavigationAgent2D.get_next_path_position()
		
		var path_length = $NavigationAgent2D.get_path_length()
		if path_length <= SHOOT_THRESHOLD and path_length != 0:
			halt()
			stopped = true
			$ShootTimer.start()
		else:
			update_facing(global_position.direction_to(next_path_position))
			var new_velocity = facing * BASE_SPEED
			$NavigationAgent2D.velocity = new_velocity


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
