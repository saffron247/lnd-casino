class_name ScreenGameOver
extends Node


# VARIABLES
var master : ScreenMaster  ## ScreenMaster parent reference.


# BUILT-IN VIRTUAL METHODS
func _ready():
	master = get_parent()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_restart_button_pressed() -> void:
	master.change_screen(ScreenMaster.Screen.GAME)
