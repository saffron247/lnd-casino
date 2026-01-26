class_name Enemy
extends CharacterBody2D


# PRELOADED SCENES
const BulletScene = preload("res://scenes/entities/enemy_bullet.tscn")


# VARIABLES
var target : Player  ## Target of the enemy's attacks.

var first_frame := true  ## True if it's the first frame (for Navigation).

@export var health := 50
@export var facing := Vector2.RIGHT


# BUILT-IN VIRTUAL METHODS
func _ready():
	# Temporary; ideally target should be assigned by main/world/level
	# initialization
	target = get_node("../../Player")
	
	# Make sure to not await during _ready.
	call_deferred("actor_setup")


## Get the NavigationServer to enable Navigation functionality.
func actor_setup() -> void:
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(target.global_position)
	first_frame = false


func _physics_process(_delta):
	# Initial setup
	if first_frame:
		return
	
	# Handle NavigationAgent finishes
	if $NavigationAgent2D.is_navigation_finished():
		set_movement_target(target.global_position)
	
	internal_routine()
	
	move_and_slide()


# ACTION METHODS
func die():
	queue_free()


func halt() -> void:
	velocity = Vector2.ZERO
	$NavigationAgent2D.velocity = Vector2.ZERO


# HELPER METHODS
func internal_routine():
	pass


## Updates the facing variable and related fields. Called once every frame.
func update_facing(new_facing: Vector2):
	facing = new_facing
	
	# Update sprite
	var sprite_angle = Vector2.RIGHT
	if velocity != Vector2.ZERO:
		sprite_angle = abs(velocity.angle())
	else:
		sprite_angle = abs(facing.angle())
		
	if sprite_angle > (PI / 2) + 0.01:
		$Sprite2D.flip_h = true
	elif sprite_angle < PI / 2 - 0.01:
		$Sprite2D.flip_h = false


# NAVIGATION HELPER METHODS
## Sets the movement target of the enemy's NavigationAgent.
func set_movement_target(movement_target: Vector2):
	$NavigationAgent2D.target_position = movement_target


# REACTION SIGNALS
func _on_hit_area_area_entered(area: Area2D) -> void:
	if area is PlayerBullet:
		health -= area.damage
		area.queue_free()
		if health < 1:
			die()
		else:
			$Sprite2D.region_rect.position.y = $Sprite2D.region_rect.size.y
			$HitTimer.start()


func _on_hit_timer_timeout() -> void:
	$Sprite2D.region_rect.position.y = 0


# NAVIGATION SIGNALS
func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
