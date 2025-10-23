class_name PlayerBullet
extends Area2D
## A bullet fired by the player.


# CONSTANTS
const SPEED = 450  ## The bullet's traveling speed.


# VARIABLES
var direction := Vector2(0, 0)  ## The direction of the bullet.


# BUILT-IN VIRTUAL METHODS
func _ready():
	rotation = direction.angle()


func _physics_process(delta: float) -> void:
	position += direction.normalized() * SPEED * delta


# SIGNALS
func _on_area_entered(_area: Area2D) -> void:
	queue_free()


func _on_body_entered(_body: Node2D) -> void:
	queue_free()
