extends GameSimulationEvent
class_name TipoffGSE


var won_by: GameSimulator.TEAM
var won_by_player: Player


func _init(gs: GameSimulator, config: Dictionary = {}):
	super(gs, config)
	Simulate(gs)


func Simulate(gs: GameSimulator):
	time_elapsed = randi_range(2, 4)
	
	var player_home: Player = gs.home_active_lineup[4]  # get the C for each team
	var player_away: Player = gs.away_active_lineup[4]
	var vr_diff = player_away.vertical_reach - player_home.vertical_reach  # weigh result by vertical reach
	var val = randfn(vr_diff, 3.0)
	if val < 0:
		won_by = GameSimulator.TEAM.HOME
		won_by_player = player_home
	else:
		won_by = GameSimulator.TEAM.AWAY
		won_by_player = player_away
	
	team = won_by
	possession = won_by
	gs.ball_handler_ix = (randi() % 2) + (0 if won_by == gs.TEAM.HOME else 5)
	
	player_locs[gs.home_active_lineup[0].id] = CourtLocation.new(
		CourtLocation.HALF.WEST, CourtLocation.AREA.TIPOFF_G, CourtLocation.SIDE.LEFT
	)
	player_locs[gs.home_active_lineup[1].id] = CourtLocation.new(
		CourtLocation.HALF.WEST, CourtLocation.AREA.TIPOFF_G, CourtLocation.SIDE.RIGHT
	)
	player_locs[gs.home_active_lineup[2].id] = CourtLocation.new(
		CourtLocation.HALF.WEST, CourtLocation.AREA.TIPOFF_F, CourtLocation.SIDE.LEFT
	)
	player_locs[gs.home_active_lineup[3].id] = CourtLocation.new(
		CourtLocation.HALF.WEST, CourtLocation.AREA.TIPOFF_F, CourtLocation.SIDE.RIGHT
	)
	player_locs[gs.home_active_lineup[4].id] = CourtLocation.new(
		CourtLocation.HALF.WEST, CourtLocation.AREA.TIPOFF_C, CourtLocation.SIDE.CENTER
	)
	player_locs[gs.away_active_lineup[0].id] = CourtLocation.new(
		CourtLocation.HALF.EAST, CourtLocation.AREA.TIPOFF_G, CourtLocation.SIDE.RIGHT
	)
	player_locs[gs.away_active_lineup[1].id] = CourtLocation.new(
		CourtLocation.HALF.EAST, CourtLocation.AREA.TIPOFF_G, CourtLocation.SIDE.LEFT
	)
	player_locs[gs.away_active_lineup[2].id] = CourtLocation.new(
		CourtLocation.HALF.EAST, CourtLocation.AREA.TIPOFF_F, CourtLocation.SIDE.RIGHT
	)
	player_locs[gs.away_active_lineup[3].id] = CourtLocation.new(
		CourtLocation.HALF.EAST, CourtLocation.AREA.TIPOFF_F, CourtLocation.SIDE.LEFT
	)
	player_locs[gs.away_active_lineup[4].id] = CourtLocation.new(
		CourtLocation.HALF.EAST, CourtLocation.AREA.TIPOFF_C, CourtLocation.SIDE.CENTER
	)
	
	description = "%s - Tipoff won by %s. Held by %s." % [
		GetTeamID(), won_by_player.character.last, (gs.home_active_lineup + gs.away_active_lineup)[gs.ball_handler_ix].character.last
	]
	next_config = {
		"is_fast_break": false,
		"is_after_made": false
	}
	next = TransitionGSE
