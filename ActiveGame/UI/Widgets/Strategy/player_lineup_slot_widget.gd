@tool
extends Panel
class_name PlayerLineupSlotWidget


signal lineup_changed


var DragPreviewScene = preload("res://ActiveGame/UI/Widgets/Strategy/player_lineup_drag_preview.tscn")


@export var pos: String = "XX":
	set(value):
		pos = value
		$HBoxContainer/Position.text = pos

var player: Player


func Activate(p: Player):
	player = p
	$HBoxContainer/Name.Activate(player)
	show()


func _get_drag_data(at_position: Vector2) -> PlayerLineupSlotWidget:
	var preview = DragPreviewScene.instantiate()
	preview.Activate(player)
	set_drag_preview(preview)
	return self

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant):
	var other = data as PlayerLineupSlotWidget
	var current_player: Player = player
	Activate(other.player)
	other.Activate(current_player)
	lineup_changed.emit()
	
