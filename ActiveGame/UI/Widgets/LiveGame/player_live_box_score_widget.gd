extends Panel
class_name PlayerLiveBoxScoreWidget


func _get_position_str(n: int) -> String:
	if n < 5:
		return ["PG", "SG", "SF", "PF", "C"][n]
	else:
		return str(n + 1)


func Activate(n: int, p: Player):
	$HBoxContainer/Position.text = _get_position_str(n)
	# player numbers are not implemented yet
	$HBoxContainer/Name.text = p.character.FullName()
	show()
