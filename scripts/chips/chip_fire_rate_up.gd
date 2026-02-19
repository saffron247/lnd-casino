extends Chip


func _on_tree_entered() -> void:
	super()
	
	player.fire_rate_multiplier += 0.2


func _on_tree_exiting() -> void:
	player.fire_rate_multiplier -= 0.2
