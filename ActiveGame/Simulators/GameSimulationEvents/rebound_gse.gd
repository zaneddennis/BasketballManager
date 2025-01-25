extends GameSimulationEvent
class_name ReboundGSE


#var rebound_loc: float  # distance from the basket, in feet
var rebound_loc: Vector2


func _init(gs: GameSimulator, config: Dictionary = {}):
	super(gs, config)
	#Simulate(gs)
	SimulateV2(gs)
	
	rebound_loc = config["rebound_location"]


func SimulateV2(gs: GameSimulator):
	print("Simulate Rebound:")
	var positioning_home = gs.home_active_lineup.map(func(p): return GetReboundPositioningV3(p))
	var positioning_away = gs.away_active_lineup.map(func(p): return GetReboundPositioningV3(p))
	var jumps_home = gs.home_active_lineup.map(func(p): return GetJumpV2(p))
	var jumps_away = gs.away_active_lineup.map(func(p): return GetJumpV2(p))
	var vals_home = GetReboundValues(positioning_home, jumps_home)
	var vals_away = GetReboundValues(positioning_away, jumps_away)
	
	var successes = Util.List.Zip([
		vals_home + vals_away,
		gs.home_active_lineup + gs.away_active_lineup,
		[gs.TEAM.HOME, gs.TEAM.HOME, gs.TEAM.HOME, gs.TEAM.HOME, gs.TEAM.HOME,
		 gs.TEAM.AWAY, gs.TEAM.AWAY, gs.TEAM.AWAY, gs.TEAM.AWAY, gs.TEAM.AWAY]
	]) # array of (val, Player, team)
	successes.sort_custom(func(a, b): return a[0] > b[0])
	var winner: Player = successes[0][1]
	var winner_team: GameSimulator.TEAM = successes[0][2]
	team = winner_team
	
	gs.ball_handler_ix = (gs.home_active_lineup + gs.away_active_lineup).find(winner)
	
	var is_off = (winner_team == gs.possession)
	player_deltas[winner.id] = Statline.new()
	player_deltas[winner.id].rebounds = 1
	description = "%s - %s %s Rebound" % [GetTeamID(), winner.character.last, "Offensive" if is_off else "Defensive"]
	
	player_locs = gs.player_locs
	
	if is_off:
		var openness: Array[float] = []
		openness.assign(
			range(5).map(
				GetOpenness
			)
		)
		
		# am I open to immediately shoot it?
		var winner_ix = offense_players.find(winner)
		var winner_openness = openness[winner_ix]
		
		# TODO: vision
		if winner_openness > 0.0:
			next = ShotGSE
			next_config = {
				"shooter": winner,
				"defender": defense_players[winner_ix],
				"shot_type": CourtLocation.SHOT_TYPES[gs.player_locs[winner.id].area]
			}
		else:
			next = HalfcourtGSEv2
			next_config["openness"] = openness
	else:
		Turnover()
		next = TransitionGSE
		next_config = {
			"is_fast_break": false,
			"is_after_made": false
		}


func GetReboundPositioningV2(p: Player, is_off: bool) -> float:
	var off_def_adj = 0.2 if is_off else 0.0  # offensive rebounding penalty should be heavier for guards
	return GameSimulator.Roll(
		p,
		{
			"rebounding": 1.5,
			"strength": 0.75,
			"agility": 0.25
		},
		2.0
	) - off_def_adj

func GetReboundPositioningV3(p: Player) -> float:
	var player_coords = player_locs[p.id].GetPosition()
	var initial_distance = 1.0 - (rebound_loc.distance_to(player_coords) / 250.0)  # ~[0, 1]
	return GameSimulator.Roll(
		p,
		{
			"rebounding": 1.0, "strength": 0.75, "agility": 0.25
		},
		0.5
	) - initial_distance

func GetJumpV2(p: Player) -> float:
	return GameSimulator.Roll(p, {"vertical_reach": 1.0, "strength": 0.25}, 0.5)

func GetReboundValues(positionings: Array, jumps: Array) -> Array[float]:
	var result: Array[float]
	
	for i in range(len(positionings)):
		var p = clamp(positionings[i], 0.0, 20.0) / 20.0
		var j = clamp(jumps[i], 0.0, 20.0)
		result.append(2 * p + j)
	
	return result

# TODO: minimum positioning cutoff
func GetReboundValuesV2(positionings: Array[float], jumps: Array[float]) -> Array[float]:
	var result: Array[float]
	
	for i in range(len(positionings)):
		result.append(positionings[i] + 0.5 * jumps[i])
	
	return result


# TODO: this is not good
func GetOpenness(ix: int) -> float:
	var offender = offense_players[ix]
	var defender = defense_players[ix]
	
	var off_roll =  GameSimulator.Roll(offender, {"off_the_ball": 1.0, "vision": 0.5}, 1.0)
	var def_roll = GameSimulator.Roll(defender, {"vision": 1.0, "positioning": 1.0}, 1.0)
	return off_roll - def_roll
