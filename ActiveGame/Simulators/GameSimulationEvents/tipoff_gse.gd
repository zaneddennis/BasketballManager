extends GameSimulationEvent
class_name TipoffGSE


var won_by: GameSimulator.TEAM


func _init(gs: GameSimulator, config: Dictionary = {}):
	super(gs, config)
	Simulate(gs)


func Simulate(gs: GameSimulator):
	time_elapsed = randi_range(4, 8)
	
	var player_home: Player = gs.home_active_lineup[4]  # get the C for each team
	var player_away: Player = gs.away_active_lineup[4]
	var vr_diff = player_away.vertical_reach - player_home.vertical_reach  # weigh result by vertical reach
	var val = randfn(vr_diff, 3.0)
	if val < 0:
		won_by = GameSimulator.TEAM.HOME
	else:
		won_by = GameSimulator.TEAM.AWAY
	
	team = won_by
	possession = won_by
	
	description = "%s - Tipoff won by %s" % [GetTeamID(), GetTeamID()]
	next = HalfcourtGSE
