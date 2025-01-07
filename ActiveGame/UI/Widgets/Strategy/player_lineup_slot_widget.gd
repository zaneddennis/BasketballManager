@tool
extends Panel
class_name PlayerLineupSlotWidget


signal lineup_changed
signal name_hovered


const DEFAULT_ROLES: Dictionary = {
	"PG": "creator",
	"SG": "combo_guard",
	"SF": "off_ball_shooter",
	"PF": "post_scorer",
	"C":  "rebounder",
}


var DragPreviewScene = preload("res://ActiveGame/UI/Widgets/Strategy/player_lineup_drag_preview.tscn")


@export var pos: String = "XX":
	set(value):
		pos = value
		$HBoxContainer/Position.text = pos
var role: PlayerRole

var player: Player


func Activate(p: Player, _role: PlayerRole=null):
	player = p
	$HBoxContainer/Name.Activate(player)
	
	FillRoles()
	role = _role
	if not role or not pos in role.valid_positions:
		if pos in DEFAULT_ROLES.keys():
			role = Database.player_roles[DEFAULT_ROLES[pos]]
		else:
			role = Database.player_roles["rebounder"]
	$HBoxContainer/Role.SelectOption(role.display_name)
	
	
	show()


func FillRoles():
	$HBoxContainer/Role.clear()
	var roles = Database.player_roles.values()
	var role_ids = roles.filter(func(r): return pos in r.valid_positions or pos.is_valid_int()).map(func(r): return r.get_unique_id())
	var display_names = roles.filter(func(r): return pos in r.valid_positions or pos.is_valid_int()).map(func(r): return r.display_name)
	$HBoxContainer/Role.Activate(display_names, role_ids)


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
	var current_role: PlayerRole = role
	Activate(other.player, other.role)
	other.Activate(current_player, current_role)
	lineup_changed.emit()


func _on_name_name_hovered(pos: Vector2, pla: Player) -> void:
	name_hovered.emit(pos, pla)


func _on_role_item_selected(index: int) -> void:
	var role_id = $HBoxContainer/Role.get_item_metadata(index)
	role = Database.player_roles[role_id]
	lineup_changed.emit()
