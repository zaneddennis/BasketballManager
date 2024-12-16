extends GameSimulationEvent
class_name ReboundGSE


func _init(gs: GameSimulator, config: Dictionary = {}):
	super(gs, config)
	Simulate(gs)


func Simulate(gs: GameSimulator):
	gs.home_active_lineup
	gs.away_active_lineup
	
	# which team is shooting?
	# gs.possession
	
	# where does the rebound go? (longer shot --> chance of longer rebound)
	var rebound_loc = clamp(randfn(6, 3), 0, 24)  # TODO: use this
	
	# how close are players to rebound destination to start with?
	# 	(TODO: do exact positioning for everyone/everything later on in GameSimulator)
	
	# how well do they get into rebounding position/box out?
	var positioning_home = gs.home_active_lineup.map(func(p): return GetReboundPositioning(p, gs.possession == gs.TEAM.HOME))
	var positioning_away = gs.away_active_lineup.map(func(p): return GetReboundPositioning(p, gs.possession == gs.TEAM.AWAY))
	var jumps_home = gs.home_active_lineup.map(func(p): return GetJump(p))
	var jumps_away = gs.away_active_lineup.map(func(p): return GetJump(p))
	
	var vals_home = GetReboundValues(positioning_home, jumps_home)
	var vals_away = GetReboundValues(positioning_away, jumps_away)
	
	# of players that are in contestable position for the rebound, who wins the jump? (vertical, weighted by rebounding position)
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
	
	var is_off = (winner_team == gs.possession)
	
	player_deltas[winner.id] = Statline.new()
	player_deltas[winner.id].rebounds = 1
	description = "%s - %s %s Rebound" % [GetTeamID(), winner.character.last, "Offensive" if is_off else "Defensive"]
	
	if not is_off:
		Turnover()
	next = HalfcourtGSE


func GetReboundPositioning(p: Player, is_off: bool) -> float:
	var skill = Util.List.Mean(
		[p.rebounding, p.strength]
	)
	var off_def_adj = 0.8 if is_off else 1.0
	return randfn(skill, 4.0) * off_def_adj

func GetJump(p: Player) -> float:
	return randfn(p.vertical_reach, 1.5)

func GetReboundValues(positionings: Array, jumps: Array) -> Array[float]:
	var result: Array[float]
	
	for i in range(len(positionings)):
		var p = clamp(positionings[i], 0.0, 20.0) / 20.0
		var j = clamp(jumps[i], 0.0, 20.0)
		result.append(p * j)
	
	return result
