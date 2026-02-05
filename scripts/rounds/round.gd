extends Node2D
class_name Round


signal round_over


var player : Player
var enemy_count := 0


func on_enemy_dead() -> void:
	enemy_count -= 1
	if enemy_count <= 0:
		round_over.emit()
		queue_free()


func _on_spawn_wait_timer_timeout() -> void:
	for child in get_children().filter(func(i): return i is SpawnEnemy):
		enemy_count += 1
		child.spawn()
	
	if enemy_count <= 0:
		print("error: Round initialized with " + str(enemy_count) + " enemies")
