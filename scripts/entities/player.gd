class_name Player
extends CharacterBody2D
## The player-controlled character.


# CONSTANTS
const BASE_SPEED = 150  ## Base movement speed.


# BUILT-IN VIRTUAL METHODS
func _physics_process(_delta):
	# Movement handling
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * BASE_SPEED
	move_and_slide()
