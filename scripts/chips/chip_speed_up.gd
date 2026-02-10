extends Chip


func _ready() -> void:
	super()
	
	player.speed_multiplier += 0.2


func on_removal() -> void:
	player.speed_multiplier -= 0.2
