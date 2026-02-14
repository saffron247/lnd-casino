class_name HUD
extends CanvasLayer


func _on_player_health_updated(new_health: int, max_health: int) -> void:
	$HealthBar.max_value = max_health
	$HealthBar.value = new_health


func _on_player_ammo_updated(new_ammo: int) -> void:
	$AmmoBar.text = ""
	for i in range(new_ammo):
		$AmmoBar.text += "O"


func _on_player_stack_updated(stack: Array, _active_start: int, _active_end: int) -> void:
	for child in $ChipStack/Container.get_children():
		child.queue_free()
	
	for child in $ActiveChips.get_children():
		child.queue_free()
	
	for i in len(stack):
		var stack_texture = TextureRect.new()
		stack_texture.texture = stack[i].stack_texture
		$ChipStack/Container.add_child(stack_texture)
		
		var active_texture = TextureRect.new()
		active_texture.texture = stack[i].full_texture
		active_texture.z_index = len(stack) - i
		$ActiveChips.add_child(active_texture)
