extends ColorRect
class_name DealChoice


# SIGNALS
signal choice_selected(chip: Chip)


var chip_instance : Chip
@export var chip : PackedScene


func _on_tree_entered() -> void:
	chip_instance = chip.instantiate()
	
	$ChipTexture.texture = chip_instance.full_texture
	$ChipNameLabel.text = chip_instance.chip_name
	$ChipDescLabel.text = chip_instance.chip_description


func _on_mouse_entered() -> void:
	scale = Vector2(1.05, 1.05)


func _on_mouse_exited() -> void:
	scale = Vector2.ONE


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		scale = Vector2.ONE
		choice_selected.emit(chip_instance)
