extends Chip


func _ready() -> void:
	super()
	
	player.damage_multiplier += 0.2


func on_removal() -> void:
	player.damage_multiplier -= 0.2
