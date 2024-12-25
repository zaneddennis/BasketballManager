extends Panel
class_name PlayerLiveBoxScoreWidget


signal name_hovered


var player: Player


func _get_position_str(n: int) -> String:
	if n < 5:
		return ["PG", "SG", "SF", "PF", "C"][n]
	else:
		return str(n + 1)


func Activate(n: int, p: Player):
	$HBoxContainer/Position.text = _get_position_str(n)
	# player numbers are not implemented yet
	$HBoxContainer/Name.text = "[url]%s[/url]" % p.character.FullName()
	player = p
	$HBoxContainer/Name.player = p
	show()


func Refresh(statline: Statline):
	$HBoxContainer/SlashLine.text = "%d / %d / %d / 0 / 0" % [
		statline.points, statline.rebounds, statline.assists
	]
	
	$HBoxContainer/Splits.text = "%d/%d FG, %d/%d 3Pt" % [
		statline.shots_made, statline.shots_att,
		statline.threes_made, statline.threes_att
	]


func _on_name_name_hovered(pos: Vector2, pla: Player) -> void:
	name_hovered.emit(pos, pla)
