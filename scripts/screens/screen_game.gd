class_name ScreenGame
extends Node
## Main game screen.


# VARIABLES
var master : ScreenMaster  ## ScreenMaster parent reference.
var round_array := [
	preload("res://scenes/rounds/round_test_1.tscn"),
	preload("res://scenes/rounds/round_test_2.tscn"),
	preload("res://scenes/rounds/round_test_3.tscn"),
]  ## Ordered list of Rounds.
var round_number := 1  ## Current Round number.
var current_round : Round  ## Reference to the current Round.

var paused := false  ## True if the game is paused.


# BUILT-IN VIRTUAL METHODS
func _ready():
	master = get_parent()
	start_next_round()


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


func start_next_round() -> void:
	$HUD/AllInLabel.hide()
	$World/Player.on_new_round()
	current_round = round_array[(round_number - 1) % len(round_array)].instantiate()
	current_round.player = $World/Player
	current_round.round_over.connect(_on_round_over)
	current_round.round_over.connect($World/Player._on_round_over)
	$World/Arena.add_child(current_round)
	$HUD/RoundLabel.text = "Round: " + str(round_number) + " "


# SIGNALS
func _on_player_game_over() -> void:
	master.change_screen(ScreenMaster.Screen.GAME_OVER)


func _on_round_over() -> void:
	$NextRoundTimer.start()


func _on_next_round_timer_timeout() -> void:
	round_number += 1
	start_next_round()
