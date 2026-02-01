class_name HUD
extends CanvasLayer


func _on_player_health_updated(new_health: int, max_health: int) -> void:
	$HealthBar.max_value = max_health
	$HealthBar.value = new_health


func _on_player_ammo_updated(new_ammo: int) -> void:
	$AmmoBar.text = ""
	for i in range(new_ammo):
		$AmmoBar.text += "O"
