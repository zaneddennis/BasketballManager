extends Panel
class_name PlayerLiveBoxScoreWidget


signal name_hovered


var player: Player
var role: PlayerRole


func _get_position_str(n: int) -> String:
	if n < 5:
		return ["PG", "SG", "SF", "PF", "  C"][n]
	else:
		return str(n + 1)

func _get_role_str() -> String:
	return role.display_abb


func Activate(n: int, p: Player, r: PlayerRole):
	player = p
	role = r
	
	$HBoxContainer/Position.text = _get_position_str(n) + " [%s]" % _get_role_str()
	
	$HBoxContainer/Number.text = str(p.jersey_number)
	$HBoxContainer/Name.text = "[url]%s[/url]" % p.character.FullName()
	$HBoxContainer/Name.player = p
	show()


func Refresh(statline: Statline, stamina: float):
	$HBoxContainer/SlashLine.text = "%d / %d / %d / %d / %d" % [
		statline.points, statline.rebounds, statline.assists, statline.steals, statline.blocks
	]
	
	$HBoxContainer/Splits.text = "%d/%d FG, %d/%d 3Pt" % [
		statline.shots_made, statline.shots_att,
		statline.threes_made, statline.threes_att
	]
	
	$HBoxContainer/Stamina.value = stamina
	var sb = StyleBoxFlat.new()
	sb.bg_color = ColorsUtil.PALLETTE.green[2]
	if stamina < 0.67:
		sb.bg_color = ColorsUtil.PALLETTE.gold[2]
	if stamina < 0.33:
		sb.bg_color = ColorsUtil.PALLETTE.red[2]
	$HBoxContainer/Stamina.add_theme_stylebox_override("fill", sb)


func _on_name_name_hovered(pos: Vector2, pla: Player) -> void:
	name_hovered.emit(pos, pla)
