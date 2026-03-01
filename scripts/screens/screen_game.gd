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

var in_round := false  ## True if the game is in a round.
var paused := false  ## True if the game is paused.
var choice_mode := false  ## True if the game is in the choice menu.
var choice_menu : ChoiceMenu


# BUILT-IN VIRTUAL METHODS
func _ready():
	master = get_parent()
	choice_menu = $HUD.get_node("ChoiceMenu")
	$HUD.remove_child(choice_menu)
	$World/Player.on_round_end()
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


func end_round() -> void:
	in_round = false
	$HUD/AllInLabel.hide()
	$World/Player.on_round_end()


func start_next_round() -> void:
	in_round = true
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
	$EndRoundTimer.start()


func _on_end_round_timer_timeout() -> void:
	end_round()
	
	if len($World/Player.chip_stack) >= $World/Player.max_chips:
		_on_next_round_timer_timeout()
	else:
		$World.process_mode = Node.PROCESS_MODE_DISABLED
		choice_mode = true
		$HUD.add_child(choice_menu)


func _on_choice_menu_choice_selected(chip: Chip) -> void:
	$HUD.remove_child(choice_menu)
	choice_mode = false
	$World.process_mode = Node.PROCESS_MODE_PAUSABLE
	$World/Player.push_chip_to_stack(chip)
	$NextRoundTimer.start()


func _on_next_round_timer_timeout() -> void:
	round_number += 1
	start_next_round()
