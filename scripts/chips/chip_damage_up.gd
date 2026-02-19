extends Chip


func _on_tree_entered() -> void:
	super()
	
	player.damage_multiplier += 0.2


func _on_tree_exiting() -> void:
	player.damage_multiplier -= 0.2
