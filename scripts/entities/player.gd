class_name Player
extends CharacterBody2D
## The player-controlled character.


# SIGNALS
signal game_over()
signal health_updated(new_health: int, max_health: int)
signal ammo_updated(new_ammo: int)
signal stack_updated(stack: Array, active_start: int, active_end: int)


# ENUMS
## State machine enum.
enum State {
	FREE = 0,  ## Idling
	SHOOT,     ## Shooting
	RELOAD     ## Reloading
}


# CONSTANTS
const TIME_BETWEEN_SHOTS = 0.5
const BASE_SPEED = 120


# PRELOADED SCENES
const BulletScn = preload("res://scenes/entities/player_bullet.tscn")


# VARIABLES
var state := State.FREE  ## Current state.
var screen_game : ScreenGame

var max_health = 10  ## Maximum health.
var health = max_health  ## Current health.
var is_invincible = false  ## True if the player can't take damage.
var max_ammo = 6  ## Maximum ammo.
var ammo = max_ammo  ## Current ammo.

var damage_multiplier = 1
var fire_rate_multiplier = 1
var speed_multiplier = 1

var chip_stack := []  ## Stack of Chips. Index 0 is the bottom of the stack.
var max_chips := 10
var max_active_chips := 3
var active_chip_start := 0
var active_chip_end := 0

@onready var screen_size := get_viewport_rect().size  ## Screen size.


# BUILT-IN VIRTUAL METHODS
func _ready() -> void:
	# Sets up resize signal
	get_tree().get_root().size_changed.connect(resize)
	screen_game = get_parent().get_parent()
	
	health_updated.emit(max_health, max_health)
	ammo_updated.emit(max_ammo)


## Triggers on screen resize; ensures attacks are directed correctly.
func resize() -> void:
	screen_size = get_viewport_rect().size


func _unhandled_input(event: InputEvent):
	if state == State.FREE and screen_game.in_round:
		if event.is_action_pressed("shoot"):
			shoot()


func _physics_process(_delta):
	# Camera handling
	$Camera2D.offset = (get_viewport().get_mouse_position() - \
		(screen_size / 2)) * 0.375
	
	if state == State.FREE and Input.is_action_pressed("shoot") \
		and screen_game.in_round:
		shoot()
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction.normalized() * (BASE_SPEED * speed_multiplier)
	move_and_slide()


# STATE TRANSITIONS
## Updates state, and handles behaviors bundled with the updating of state.
func update_state(new_state: State):
	if state == new_state:
		return
	
	match new_state:
		State.SHOOT:
			$ShootTimer.start(TIME_BETWEEN_SHOTS / fire_rate_multiplier)
		State.RELOAD:
			$ReloadTimer.start()
	
	state = new_state


# ACTION METHODS
## Shoots a bullet in the direction of the mouse cursor.
func shoot() -> void:
	update_state(State.SHOOT)
	
	var mouse_position = get_viewport().get_mouse_position()
	var attack_direction = (screen_size / 2).direction_to(mouse_position)
	var bullet := BulletScn.instantiate()
	bullet.direction = attack_direction
	bullet.position = position + (attack_direction * 10.0)
	bullet.damage *= damage_multiplier
	add_sibling(bullet)
	
	ammo -= 1
	ammo_updated.emit(ammo)


## Reloads ammo to max.
func reload() -> void:
	if active_chip_start == 0 and active_chip_end == 0:
		health = max(health - 1, 1)
		is_invincible = true
		health_updated.emit(health, max_health)
		$Sprite2D.region_rect.position.y = $Sprite2D.region_rect.size.y
		$HitTimer.start()
	else:
		pop_chip_from_active_stack()
	ammo = max_ammo
	ammo_updated.emit(ammo)
	update_state(State.FREE)


# CHIP MANAGEMENT METHODS
func push_chip_to_stack(chip: Chip):
	chip.player = self
	chip_stack.push_back(chip)
	active_chip_end += 1
	active_chip_start = max(0, active_chip_end - max_active_chips)
	activate_active_chips()


func activate_active_chips():
	for child in $ActiveChipStack.get_children():
		$ActiveChipStack.remove_child(child)
	
	for i in range(active_chip_start, active_chip_end):
		$ActiveChipStack.add_child(chip_stack[i])
		$ActiveChipStack.move_child(chip_stack[i], 0)
	
	stack_updated.emit(chip_stack, active_chip_start, active_chip_end)


func pop_chip_from_active_stack():
	$ActiveChipStack.remove_child(chip_stack[active_chip_end - 1])
	
	if active_chip_start - 1 >= 0:
		active_chip_start -= 1
		$ActiveChipStack.add_child(chip_stack[active_chip_start])
		$ActiveChipStack.move_child(chip_stack[active_chip_start], 0)
	active_chip_end = max(active_chip_end - 1, 0)
	
	stack_updated.emit(chip_stack, active_chip_start, active_chip_end)


# PSEUDO-SIGNALS
func on_round_end() -> void:
	update_state(State.FREE)
	$ReloadTimer.stop()
	ammo = max_ammo
	ammo_updated.emit(ammo)
	
	active_chip_end = len(chip_stack)
	active_chip_start = max(0, active_chip_end - max_active_chips)
	activate_active_chips()


# SIGNALS
func _on_shoot_timer_timeout() -> void:
	if ammo > 0:
		update_state(State.FREE)
	else:
		update_state(State.RELOAD)


func _on_reload_timer_timeout() -> void:
	reload()


func _on_hit_area_area_entered(area: Area2D) -> void:
	if area is EnemyBullet:
		area.queue_free()
		if not is_invincible:
			health -= 1
			if health < 1:
				game_over.emit()
			else:
				is_invincible = true
				health_updated.emit(health, max_health)
				$Sprite2D.region_rect.position.y = $Sprite2D.region_rect.size.y
				$HitTimer.start()


func _on_hit_timer_timeout() -> void:
	is_invincible = false
	$Sprite2D.region_rect.position.y = 0


func _on_round_over() -> void:
	$ReloadTimer.stop()
