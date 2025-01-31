extends GameSimulationEvent
class_name ShotGSE


enum SHOT_TYPE {DUNK, LAYUP, SHORT, MIDRANGE, LONG_TWO, THREE, LONG_THREE}
var SHOT_WORTH = {  # todo: make this stuff into a real (tabular?) database at some point
	SHOT_TYPE.LAYUP: 2,
	SHOT_TYPE.SHORT: 2,
	SHOT_TYPE.MIDRANGE: 2,
	SHOT_TYPE.THREE: 3,
	SHOT_TYPE.LONG_THREE: 3,
}


var SHOT_DIFFICULTY = {
	SHOT_TYPE.LAYUP: 0.0,
	SHOT_TYPE.SHORT: 0.1,
	SHOT_TYPE.MIDRANGE: 0.15,
	SHOT_TYPE.THREE: 0.25,
	SHOT_TYPE.LONG_THREE: 0.4
}

#var SHOT_DISTANCE = {
#	SHOT_TYPE.LAYUP: 0,
#	SHOT_TYPE.SHORT: 6,
#	SHOT_TYPE.MIDRANGE: 12,
#	SHOT_TYPE.THREE: 24,
#	SHOT_TYPE.LONG_THREE: 30
#}

const O_RATIO: float = 1.2
const D_RATIO: float = 0.8


var shot_type: SHOT_TYPE
var shot_type_text: String
var shooter: Player
var defender: Player
var passer: Player
var make: bool
var points: int = 0


func _init(gs: GameSimulator, config: Dictionary = {}):
	super(gs, config)
	
	team = gs.possession
	
	shot_type = config["shot_type"]
	shot_type_text = SHOT_TYPE.keys()[shot_type].capitalize()
	shooter = config["shooter"]
	defender = config["defender"]
	if "passer" in config:
		passer = config["passer"]
	
	player_deltas[shooter.id] = Statline.new()
	if passer:
		player_deltas[passer.id] = Statline.new()
	player_deltas[defender.id] = Statline.new()
	
	Simulate(gs)


func Simulate(gs: GameSimulator):
	print("Simulate shot")
	time_elapsed = randi_range(1, min(2, gs.time))

	var worth = SHOT_WORTH[shot_type]
	var difficulty = SHOT_DIFFICULTY[shot_type]
	
	var offense = GameSimulator.Roll(
		shooter,
		{
			"finishing": 1.0
		} if shot_type == SHOT_TYPE.LAYUP else
		{
			"shooting": 1.0
		},
		0.5
	)
	var defense = GameSimulator.Roll(
		defender,
		{
			"vertical_reach": 0.75,
			"interior_defense": 1.0
		} if shot_type == SHOT_TYPE.LAYUP else
		{
			"vertical_reach": 0.25,
			"perimeter_defense": 1.0,
		},
		0.25
	)
	var contest = O_RATIO * offense - D_RATIO * defense
	print("%f = %.1f*%.3f - %.1f*%.3f" % [contest, O_RATIO, offense, D_RATIO, defense])
	
	make = contest >= difficulty
	var result = "MISSED"
	#var points = 0
	points = 0
	if make:
		result = "MADE"
		points = worth
		player_deltas[shooter.id].shots_made = 1
		if worth == 3:
			player_deltas[shooter.id].threes_made = 1
		if passer:
			player_deltas[passer.id].assists = 1
		
		Turnover()
		next = TransitionGSE
		next_config = {
			"is_fast_break": false,
			"is_after_made": true
		}
		gs.ball_pos = Vector2(22, 0)
	else:
		if contest < -0.5:
			result = "BLOCKED"
			player_deltas[defender.id].blocks = 1
		
		next = ReboundGSE
		var rebound_vector = Vector2.from_angle(randf_range(0, PI)).rotated(PI/-2)
		gs.ball_pos = Vector2(22, 0) + rebound_vector * randf_range(10, 16)
		next_config["rebound_location"] = Vector2(22, 0) + rebound_vector * abs(randfn(0, 50))
	
	gs.ball_half = player_locs[shooter.id].half
	gs.ball_handler_ix = -1
	
	if points > 0:
		Score(points, gs)
	
	player_deltas[shooter.id].shots_att = 1
	if worth == 3:
		player_deltas[shooter.id].threes_att = 1
	player_deltas[shooter.id].points = points
	
	description = "%s - %s %s (%s defends) - %s [+%d]" % [GetTeamID(), shooter.character.last, shot_type_text, defender.character.last, result, points]
	
	player_locs = gs.player_locs
	
	player_staminas[shooter.id] = 0.005
	player_staminas[defender.id] = 0.005


func Score(points: int, gs: GameSimulator):
	if team == gs.TEAM.HOME:
		home_score_add = points
	else:
		away_score_add = points
