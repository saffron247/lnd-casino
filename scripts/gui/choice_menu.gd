extends Control
class_name ChoiceMenu


# SIGNALS
signal choice_selected(chip: Chip)


func _on_deal_choice_choice_selected(chip: Chip) -> void:
	choice_selected.emit(chip)
