class_name ScreenMaster
extends Node
## Used to switch between scenes of the game. The node highest in the hierarchy
## just below the root.


# ENUMS
## Screen enum.
enum Screen {
	GAME = 0,
	GAME_OVER
}


# PRELOADED SCENES
const GameScene = preload("res://scenes/screens/screen_game.tscn")
const GameOverScene = preload("res://scenes/screens/screen_game_over.tscn")


# VARIABLES
var current_screen : Screen
var screen_instance : Node


# BUILT-IN VIRTUAL METHODS
func _ready():
	current_screen = Screen.GAME
	screen_instance = GameScene.instantiate()
	add_child(screen_instance)


# ACTION METHODS
## Change the screen to a new one.
func change_screen(to: Screen):
	# New screen entry behavior
	var new_instance : Node
	match to:
		Screen.GAME:
			new_instance = GameScene.instantiate()
		Screen.GAME_OVER:
			new_instance = GameOverScene.instantiate()
	
	# Finalize change
	call_deferred("add_child", new_instance)
	screen_instance.queue_free()
	screen_instance = new_instance
	current_screen = to
