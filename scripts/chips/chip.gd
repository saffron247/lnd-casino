extends Node2D
class_name Chip


var player : Player
var parent : Node2D


@export var full_texture : Texture
@export var stack_texture : Texture


func _ready() -> void:
	parent = get_parent()


func on_removal() -> void:
	pass
