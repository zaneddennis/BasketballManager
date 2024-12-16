extends Panel
class_name PlayerLiveBoxScoreWidget


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
