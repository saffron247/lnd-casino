class_name CursorSprite
extends Node2D
## Represents the cursor on the screen.


# BUILT-IN VIRTUAL METHODS
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _physics_process(_delta):
	position = get_viewport().get_mouse_position()
