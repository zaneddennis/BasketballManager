extends GameSimulationEvent
class_name ShotGSE


enum SHOT_TYPE {DUNK, LAYUP, SHORT, MIDRANGE, LONG_TWO, THREE, LONG_THREE}
var SHOT_WORTH = {  # todo: make this stuff into a real (tabular?) database at some point
	SHOT_TYPE.LAYUP: 2,
	SHOT_TYPE.MIDRANGE: 2,
	SHOT_TYPE.THREE: 3,
}
# p = a * off + b * def + c
#var SHOT_PARAMS = {
#	SHOT_TYPE.LAYUP: [0.0197, -0.0348, 0.692],
#	SHOT_TYPE.MIDRANGE: [0.0268, -0.019, 0.280],
#	SHOT_TYPE.THREE: [0.0236, -0.016, 0.168]
#}

var SHOT_DIFFICULTY = {
	SHOT_TYPE.LAYUP: 0.3,
	SHOT_TYPE.MIDRANGE: 0.5,
	SHOT_TYPE.THREE: 0.7
}

var SHOT_DISTANCE = {
	SHOT_TYPE.LAYUP: 0,
	SHOT_TYPE.MIDRANGE: 12,
	SHOT_TYPE.THREE: 24
}


var shot_type: SHOT_TYPE
var shot_type_text: String
var shooter: Player
var defender: Player
var passer: Player


func _init(gs: GameSimulator, config: Dictionary = {}):
	super(gs, config)
	
	team = gs.possession
	
	shot_type = config["shot_type"]
	shot_type_text = SHOT_TYPE.keys()[shot_type].capitalize()
	shooter = config["shooter"]
	defender = config["defender"]
	passer = config["passer"]
	
	player_deltas[shooter.id] = Statline.new()
	player_deltas[passer.id] = Statline.new()
	
	Simulate(gs)


func Simulate(gs: GameSimulator):
	print("Simulate shot")
	time_elapsed = randi_range(1, min(3, gs.time))

	var worth = SHOT_WORTH[shot_type]
	var difficulty = SHOT_DIFFICULTY[shot_type]
	#var shooter_skill = shooter.finishing if shot_type == SHOT_TYPE.LAYUP else shooter.shooting
	#var defender_skill = defender.interior_defense if shot_type == SHOT_TYPE.LAYUP else defender.perimeter_defense
	
	#var adj_difficulty = _shot_probability(shooter_skill, defender_skill)
	var defense = GameSimulator.Roll(
		defender,
		#{
		#	"vertical_reach": 1.0,
		#	"interior_defense" if shot_type == SHOT_TYPE.LAYUP else "perimeter_defense": 1.0,
		#},
		{
			"vertical_reach": 0.75,
			"interior_defense": 1.0
		} if shot_type == SHOT_TYPE.LAYUP else
		{
			"vertical_reach": 0.25,
			"perimeter_defense": 1.0,
		},
		0.5
	)
	var offense = GameSimulator.Roll(
		shooter,
		{
			"finishing": 1.0
		} if shot_type == SHOT_TYPE.LAYUP else
		{
			"shooting": 1.0
		},
		1.5
	)
	var contest = offense - defense
	print("%f = %f - %f" % [contest, offense, defense])
	
	var make = contest >= difficulty
	var result = "MISSED"
	var points = 0
	if make:
		result = "MADE"
		points = worth
		player_deltas[shooter.id].shots_made = 1
		if worth == 3:
			player_deltas[shooter.id].threes_made = 1
		player_deltas[passer.id].assists = 1
		
		Turnover()
		next = HalfcourtGSE
	else:
		next = ReboundGSE
		next_config["rebound_location"] = clamp(randfn(SHOT_DISTANCE[shot_type] / 4, 3), 0, 24)
	
	if points > 0:
		Score(points, gs)
	
	player_deltas[shooter.id].shots_att = 1
	if worth == 3:
		player_deltas[shooter.id].threes_att = 1
	player_deltas[shooter.id].points = points
	description = "%s - %s %s (%s defends) - %s [+%d]" % [GetTeamID(), shooter.character.last, shot_type_text, defender.character.last, result, points]


func Score(points: int, gs: GameSimulator):
	if team == gs.TEAM.HOME:
		home_score_add = points
	else:
		away_score_add = points


#func _shot_probability(off: int, def: int) -> float:
#	var params = SHOT_PARAMS[shot_type]
#	
#	return params[0] * off + params[1] * def + params[2]
