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

@export var right_color: Color = Color.WHITE:
	set(value):
		right_color = value
		if $Right:
			$Right.add_theme_color_override("font_color", right_color)
