class_name ScreenGame
extends Node
## Main game screen.


# VARIABLES
var master : ScreenMaster  ## ScreenMaster parent reference.

var paused := false  ## True if the game is paused.


# BUILT-IN VIRTUAL METHODS
func _ready():
	master = get_parent()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if paused:
			unpause()
		else:
			pause()


# METHODS
func pause() -> void:
	get_tree().paused = true
	$HUD/PauseMenu.show()
	paused = true


func unpause() -> void:
	get_tree().paused = false
	$HUD/PauseMenu.hide()
	paused = false


# SIGNALS
func _on_player_game_over() -> void:
	master.change_screen(ScreenMaster.Screen.GAME_OVER)
