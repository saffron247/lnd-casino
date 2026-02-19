class_name HUD
extends CanvasLayer


var max_chips = 10
var max_active = 3


func _ready() -> void:
	max_chips = $ChipStack/Container.get_child_count()
	max_active = $ActiveChips.get_child_count()


func _on_player_health_updated(new_health: int, max_health: int) -> void:
	$HealthBar.max_value = max_health
	$HealthBar.value = new_health


func _on_player_ammo_updated(new_ammo: int) -> void:
	$AmmoBar.text = ""
	for i in range(new_ammo):
		$AmmoBar.text += "O"


func _on_player_stack_updated(stack: Array, active_start: int, active_end: int) -> void:
	for child in $ActiveChips.get_children():
		child.hide()
	
	if active_start == 0 and active_end == 0:
		$AllInLabel.show()
	
	for i in range(max_chips):
		var stack_slot = $ChipStack/Container.get_child(i)
		if (max_chips - i - 1) >= active_end:
			stack_slot.hide()
			stack_slot.deactivate()
		else:
			stack_slot.texture = stack[max_chips - len(stack) - i - 1].stack_texture
			stack_slot.show()
			
			if (max_chips - i - 1) in range(active_start, active_end):
				if i == 0:
					stack_slot.activate(StackSlot.StackPosition.TOP)
				elif i == max_chips - 1:
					stack_slot.activate(StackSlot.StackPosition.BOTTOM)
				else:
					stack_slot.activate()
			
				var active_slot = $ActiveChips.get_child(max_active - (max_chips - active_start - i))
				active_slot.texture = stack[max_chips - len(stack) - i - 1].full_texture
				active_slot.show()
			else:
				stack_slot.deactivate()
