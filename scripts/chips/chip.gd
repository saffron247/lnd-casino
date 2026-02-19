extends Node2D
class_name Chip


var player : Player
var parent : Node2D


@export var full_texture : Texture
@export var stack_texture : Texture


func _on_tree_entered() -> void:
	parent = get_parent()


func _on_tree_exiting() -> void:
	pass # Replace with function body.
