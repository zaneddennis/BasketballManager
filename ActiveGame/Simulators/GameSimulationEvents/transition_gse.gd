extends GameSimulationEvent
class_name TransitionGSE


var is_fast_break: bool = false
var is_after_made: bool = false


func _init(gs: GameSimulator, config: Dictionary = {}):
	super(gs, config)
	team = gs.possession
	is_fast_break = config["is_fast_break"]
	is_after_made = config["is_after_made"]
	
	Simulate(gs)


func Simulate(gs: GameSimulator):
	time_elapsed = randi_range(4, 8)
	
	var handler_options = offense_players.slice(0, 3)  # TODO: weigh by Role
	if is_after_made:
		gs.SetBallhandler(handler_options.pick_random())
	else:
		if not gs.GetBallHandlingPlayer() in handler_options:
			gs.SetBallhandler(handler_options.pick_random())
	
	if is_fast_break:
		SimulateFastBreak(gs)
	else:
		SimulateSlowTransition(gs)

func SimulateSlowTransition(gs: GameSimulator):
	description = "%s - Transition. %s handles." % [GetTeamID(), (gs.home_active_lineup + gs.away_active_lineup)[gs.ball_handler_ix].character.last]
	
	var openness: Array[float] = []
	openness.assign(
		range(5).map(
			GetOpennessSlowTransition
		)
	)
	
	var half = CourtLocation.HALF.EAST if gs.possession == gs.TEAM.HOME else CourtLocation.HALF.WEST
	player_locs[offense_players[0].id] = CourtLocation.new(
		half, CourtLocation.AREA.VALVE, CourtLocation.SIDE.CENTER
	)
	player_locs[offense_players[1].id] = CourtLocation.new(
		half, CourtLocation.AREA.VALVE, CourtLocation.SIDE.LEFT
	)
	player_locs[offense_players[2].id] = CourtLocation.new(
		half, CourtLocation.AREA.VALVE, CourtLocation.SIDE.RIGHT
	)
	player_locs[offense_players[3].id] = CourtLocation.new(
		half, CourtLocation.AREA.FT_LINE, CourtLocation.SIDE.RIGHT
	)
	player_locs[offense_players[4].id] = CourtLocation.new(
		half, CourtLocation.AREA.FT_LINE, CourtLocation.SIDE.LEFT
	)
	player_locs[defense_players[0].id] = CourtLocation.new(
		half, CourtLocation.AREA.VALVE, CourtLocation.SIDE.CENTER, openness[0]
	)
	player_locs[defense_players[1].id] = CourtLocation.new(
		half, CourtLocation.AREA.VALVE, CourtLocation.SIDE.LEFT, openness[1]
	)
	player_locs[defense_players[2].id] = CourtLocation.new(
		half, CourtLocation.AREA.VALVE, CourtLocation.SIDE.RIGHT, openness[2]
	)
	player_locs[defense_players[3].id] = CourtLocation.new(
		half, CourtLocation.AREA.FT_LINE, CourtLocation.SIDE.RIGHT, openness[3]
	)
	player_locs[defense_players[4].id] = CourtLocation.new(
		half, CourtLocation.AREA.FT_LINE, CourtLocation.SIDE.LEFT, openness[4]
	)
	
	next_config["openness"] = openness
	next = HalfcourtGSEv2

func GetOpennessSlowTransition(ix: int) -> float:
	# var offender = offense_players[ix]
	var defender = defense_players[ix]
	return GameSimulator.Roll(defender, {"vision": 1.0, "positioning": 1.0}, 0.25)


func SimulateFastBreak(gs: GameSimulator):
	description = "%s - Fast Break" % GetTeamID()
