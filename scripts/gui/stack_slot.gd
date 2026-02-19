extends TextureRect
class_name StackSlot


enum StackPosition {
	TOP = 0,
	MIDDLE,
	BOTTOM
}


const StackHighlightTop = preload("res://assets/gui/stack_highlight_top.png")
const StackHighlightMiddle = preload("res://assets/gui/stack_highlight_middle.png")
const StackHighlightBottom = preload("res://assets/gui/stack_highlight_bottom.png")


func activate(stack_position := StackPosition.MIDDLE):
	match stack_position:
		StackPosition.MIDDLE:
			$Highlight.texture = StackHighlightMiddle
		StackPosition.TOP:
			$Highlight.texture = StackHighlightTop
		StackPosition.BOTTOM:
			$Highlight.texture = StackHighlightBottom
	
	$Highlight.show()


func deactivate():
	$Highlight.hide()
