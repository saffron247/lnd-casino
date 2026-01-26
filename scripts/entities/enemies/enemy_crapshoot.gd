class_name EnemyCrapshoot
extends Enemy


const BASE_SPEED = 50
const MOVE_THRESHOLD = 50


func internal_routine():
		set_movement_target(target.global_position)
		var next_path_position = $NavigationAgent2D.get_next_path_position()
		
		var path_length = $NavigationAgent2D.get_path_length()
		if path_length <= MOVE_THRESHOLD and path_length != 0:
			halt()
		else:
			update_facing(global_position.direction_to(next_path_position))
			var new_velocity = facing * BASE_SPEED
			$NavigationAgent2D.velocity = new_velocity


func shoot():
	var bullet_count = randi_range(2, 4)
	var bullets = []
	for i in range(bullet_count):
		bullets.append(BulletScene.instantiate())
	
	var attack_direction = position.direction_to(target.position)
	match bullet_count:
		2:
			bullets[0].direction = attack_direction.rotated(PI / 24)
			bullets[1].direction = attack_direction.rotated(PI / -24)
		3:
			bullets[0].direction = attack_direction.rotated(PI / 12)
			bullets[1].direction = attack_direction
			bullets[2].direction = attack_direction.rotated(PI / -12)
		4:
			bullets[0].direction = attack_direction.rotated(PI / 8)
			bullets[1].direction = attack_direction.rotated(PI / 24)
			bullets[2].direction = attack_direction.rotated(PI / -24)
			bullets[3].direction = attack_direction.rotated(PI / -8)
	
	for bullet in bullets:
		bullet.position = position + (bullet.direction * 10.0)
		add_sibling(bullet)


func _on_shoot_timer_timeout():
	shoot()
