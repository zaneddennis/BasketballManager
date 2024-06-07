@tool
extends HBoxContainer
class_name OuterJustifyWidget

@export var left: String:
	set(value):
		left = value
		if $Left:
			$Left.text = left
@export var right: String:
	set(value):
		right = value
		if $Right:
			$Right.text = right
