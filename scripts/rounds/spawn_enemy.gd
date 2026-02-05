extends Sprite2D
class_name SpawnEnemy


@export var enemy_scene : PackedScene


func spawn():
	var enemy : Enemy = enemy_scene.instantiate()
	enemy.global_position = global_position
	add_sibling(enemy)
	queue_free()
