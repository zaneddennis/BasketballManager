extends GameSimulationEvent
class_name ShotGSE


enum SHOT_TYPE {DUNK, LAYUP, SHORT, MIDRANGE, LONG_TWO, THREE, LONG_THREE}
var SHOT_WORTH = {  # todo: make this stuff into a real (tabular?) database at some point
	SHOT_TYPE.LAYUP: 2,
	SHOT_TYPE.MIDRANGE: 2,
	SHOT_TYPE.THREE: 3,
}
# p = a * off + b * def + c
var SHOT_PARAMS = {
	SHOT_TYPE.LAYUP: [0.0197, -0.0348, 0.692],
	SHOT_TYPE.MIDRANGE: [0.0268, -0.019, 0.280],
	SHOT_TYPE.THREE: [0.0236, -0.016, 0.168]
}



var shot_type: SHOT_TYPE
var shot_type_text: String
var shooter: Player
var defender: Player


func _init(gs: GameSimulator, config: Dictionary = {}):
	super(gs, config)
	
	team = gs.possession
	
	shot_type = config["shot_type"]
	shot_type_text = SHOT_TYPE.keys()[shot_type].capitalize()
	shooter = config["shooter"]
	defender = config["defender"]
	
	Simulate(gs)

func Simulate(gs: GameSimulator):
	time_elapsed = randi_range(1, min(3, gs.time))

	var worth = SHOT_WORTH[shot_type]
	var shooter_skill = shooter.finishing if shot_type == SHOT_TYPE.LAYUP else shooter.shooting
	var defense = defender.interior_defense if shot_type == SHOT_TYPE.LAYUP else defender.perimeter_defense
	
	var adj_difficulty = _shot_probability(shooter_skill, defense)
	
	var make = randf() < adj_difficulty
	var result = "MISSED"
	var points = 0
	if make:
		result = "MADE"
		points = worth
		
		Turnover()
		next = HalfcourtGSE
	else:
		next = ReboundGSE
	
	if points > 0:
		Score(points, gs)
	
	description = "%s - %s %s (%s defends) - %s [+%d]" % [GetTeamID(), shooter.character.last, shot_type_text, defender.character.last, result, points]


func Score(points: int, gs: GameSimulator):
	if team == gs.TEAM.HOME:
		home_score_add = points
	else:
		away_score_add = points


func _shot_probability(off: int, def: int) -> float:
	var params = SHOT_PARAMS[shot_type]
	
	return params[0] * off + params[1] * def + params[2]
