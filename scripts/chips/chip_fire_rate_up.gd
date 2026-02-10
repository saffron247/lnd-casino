extends Chip


func _ready() -> void:
	super()
	
	player.fire_rate_multiplier += 0.2


func on_removal() -> void:
	player.fire_rate_multiplier -= 0.2
