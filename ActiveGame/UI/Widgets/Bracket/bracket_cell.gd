@tool
extends Control
class_name BracketCell


const CELL_LENGTH = 192
const UNIT_HEIGHT = 24


@export var round: int = 1:
	set(val):
		round = val
		
		# set height
		var height = UNIT_HEIGHT * (2**round + 1)
		custom_minimum_size = Vector2(CELL_LENGTH, height)
		$LineLower.position.y = height
		$LineSide.points[1].y = height
		$Lower.position.y = height - UNIT_HEIGHT


func ActivateV2(ix: int, r: int, t: Tournament, game_ix: int):
	round = r
	
	position = Vector2(
		CELL_LENGTH * (r - 1),
		UNIT_HEIGHT * ((2**(r-1)-1) + ix * (2**(1+r)))
	)
	
	var pairing = t.bracket[r][ix]
	
	# set upper
	if pairing[0] == 0:
		$Upper.hide()
	else:
		$Upper/Seed.text = "[%d]" % pairing[0]
		$Upper/Team.text = t.teams[pairing[0] - 1].school.short_name
	
	# set lower
	if pairing[1] == 0:
		$Lower.hide()
	else:
		$Lower/Seed.text = "[%d]" % pairing[1]
		$Lower/Team.text = t.teams[pairing[1] - 1].school.short_name
	
	# if game exists and has been played?
	if game_ix < len(t.games):
		var g = t.games[game_ix]
		if g.home_score:
			$Upper/Score.text = str(g.home_score)
			$Lower/Score.text = str(g.away_score)

func Activate(ix: int, r: int, pairing: Array[int] = [], g: Game = null):
	round = r
	
	position = Vector2(
		CELL_LENGTH * (r - 1),
		UNIT_HEIGHT * ((2**(r-1)-1) + ix * (2**(1+r)))
	)
	
	if pairing and g:
		print(g)
		print("\t", g.home_score, g.away_score)
		$Upper/Team.text = g.home.school.short_name
		$Upper/Seed.text = "[%d]" % pairing[0]
		$Lower/Team.text = g.away.school.short_name
		$Lower/Seed.text = "[%d]" % pairing[1]
		
		if g.home_score:
			$Upper/Score.text = str(g.home_score)
			$Lower/Score.text = str(g.away_score)
		
	else:
		$Upper.hide()
		$Lower.hide()
