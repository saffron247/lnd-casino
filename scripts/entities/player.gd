class_name Player
extends CharacterBody2D
## The player-controlled character.


# ENUMS
## State machine enum.
enum State {
	FREE = 0,  ## Idling
	SHOOT,     ## Shooting
	RELOAD     ## Reloading
}


# PRELOADED SCENES
const BulletScn = preload("res://scenes/entities/player_bullet.tscn")


# VARIABLES
var state := State.FREE  ## Current state.
var base_speed = 150  ## Base movement speed.
var max_ammo = 6  ## Maximum ammo.
var ammo = max_ammo  ## Current ammo.
@onready var screen_size := get_viewport_rect().size  ## Screen size.


# BUILT-IN VIRTUAL METHODS
func _ready() -> void:
	# Sets up resize signal
	get_tree().get_root().size_changed.connect(resize)


## Triggers on screen resize; ensures attacks are directed correctly.
func resize() -> void:
	screen_size = get_viewport_rect().size


func _unhandled_input(event: InputEvent):
	if state == State.FREE:
		if event.is_action_pressed("shoot"):
			shoot()


func _physics_process(_delta):
	if state == State.FREE and Input.is_action_pressed("shoot"):
		shoot()
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * base_speed
	move_and_slide()


# STATE TRANSITIONS
## Updates state, and handles behaviors bundled with the updating of state.
func update_state(new_state: State):
	if state == new_state:
		return
	
	match new_state:
		State.SHOOT:
			$ShootTimer.start()
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
	add_sibling(bullet)
	
	ammo -= 1


## Reloads ammo to max.
func reload() -> void:
	ammo = max_ammo
	update_state(State.FREE)


# SIGNALS
func _on_shoot_timer_timeout() -> void:
	if ammo > 0:
		update_state(State.FREE)
	else:
		update_state(State.RELOAD)


func _on_reload_timer_timeout() -> void:
	reload()
