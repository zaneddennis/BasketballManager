extends GameSimulationEvent
class_name HalfcourtGSE_OLD


# note: this will be affected by Strategy
# this refers to where a player might be receiving a pass (layup, midrange, 3)
var position_location_weights = {
	Constants.PG: [1.5, 0.5, 2.0],
	Constants.SG: [1.5, 0.5, 2.0],
	Constants.SF: [2.0, 0.5, 1.5],
	Constants.PF: [2.5, 1.0, 0.5],
	Constants.C:  [3.0, 0.5, 0.0],
}


func _init(gs: GameSimulator, config: Dictionary = {}):
	super(gs, config)
	team = gs.possession
	Simulate(gs)
	
	
func Simulate(gs: GameSimulator):
	time_elapsed = randi_range(5, min(30, gs.time))
	description = "%s - Halfcourt Offense - " % GetTeamID()
	
	var primary_handler = offense_players[Constants.PG]
	var primary_defender = defense_players[Constants.PG]
	
	# "ability" values are theoretically [-20, 20]
	var iso_ability = (primary_handler.ball_handling - primary_defender.perimeter_defense)  # todo: more attributes
	# todo: let other players ballhandle
	var open_otb_abilities = [
		offense_players[Constants.SG].off_the_ball - defense_players[Constants.SG].positioning,
		offense_players[Constants.SF].off_the_ball - defense_players[Constants.SF].positioning,
		offense_players[Constants.PF].off_the_ball - defense_players[Constants.PF].positioning,
		offense_players[Constants.C].off_the_ball - defense_players[Constants.C].positioning
	]
	
	# "attribute" values are [0, 20]
	var vision_attr = primary_handler.vision
	
	# "val" values are [0, 1]
	var iso_val = 0.5 + (clamp(randfn(iso_ability, 5.0), -20.0, 20.0) / 40.0)
	var open_otb_vals = [
		0.5 + (clamp(randfn(open_otb_abilities[0], 5.0), -20.0, 20.0) / 40.0),
		0.5 + (clamp(randfn(open_otb_abilities[1], 5.0), -20.0, 20.0) / 40.0),
		0.5 + (clamp(randfn(open_otb_abilities[2], 5.0), -20.0, 20.0) / 40.0),
		0.5 + (clamp(randfn(open_otb_abilities[3], 5.0), -20.0, 20.0) / 40.0)
	]
	
	# if really bad iso, turnover
	if iso_val < 0.1:
		Turnover()
		description += "Turnover"
		next = HalfcourtGSEv2  #TODO: fast breaks
	
	else:
		# if someone really open, pass to them and they shoot (shot location/type depends on position)
		var most_open_val = open_otb_vals.max()
		if most_open_val > 0.6:
			var most_open_ix = open_otb_vals.find(open_otb_vals.max()) + 1  # offset for PG
			var passer = primary_handler  # todo: other passers
			var recipient = offense_players[most_open_ix]
			var defender = defense_players[most_open_ix]
			description += "%s - Pass to %s" % [passer.character.last, recipient.character.last]
			next = ShotGSE
			next_config = {
				"shot_type": _determine_shot_type_catch(most_open_ix),
				"shooter": recipient,
				"defender": defender,
				"passer": primary_handler
			}
		
		# all else fails, try an iso
		else:
			var dribbler = primary_handler
			var defender = primary_defender
			description += "%s Iso vs %s - " % [dribbler.character.last, defender.character.last]
			if iso_val > 0.6:
				description += "Open"
				next = ShotGSE
				next_config = {
					"shot_type": _determine_shot_type_iso(),
					"shooter": dribbler,
					"defender": defender,
					"passer": primary_handler
				}
			else:
				description += "Contested"
				next = ShotGSE
				next_config = {
					"shot_type": _determine_shot_type_iso(),
					"shooter": dribbler,
					"defender": defender,
					"passer": primary_handler
				}
	
	# player locs
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
		half, CourtLocation.AREA.FT_LINE, CourtLocation.SIDE.CENTER
	)
	player_locs[offense_players[4].id] = CourtLocation.new(
		half, CourtLocation.AREA.BLOCK, CourtLocation.SIDE.LEFT
	)
	player_locs[defense_players[0].id] = CourtLocation.new(
		half, CourtLocation.AREA.VALVE, CourtLocation.SIDE.CENTER, true
	)
	player_locs[defense_players[1].id] = CourtLocation.new(
		half, CourtLocation.AREA.VALVE, CourtLocation.SIDE.LEFT, true
	)
	player_locs[defense_players[2].id] = CourtLocation.new(
		half, CourtLocation.AREA.VALVE, CourtLocation.SIDE.RIGHT, true
	)
	player_locs[defense_players[3].id] = CourtLocation.new(
		half, CourtLocation.AREA.FT_LINE, CourtLocation.SIDE.CENTER, true
	)
	player_locs[defense_players[4].id] = CourtLocation.new(
		half, CourtLocation.AREA.BLOCK, CourtLocation.SIDE.LEFT, true
	)
	#player_locs = gs.player_locs


func _determine_shot_type_catch(receiver_position: int) -> ShotGSE.SHOT_TYPE:
	var options = [
		ShotGSE.SHOT_TYPE.LAYUP, ShotGSE.SHOT_TYPE.MIDRANGE, ShotGSE.SHOT_TYPE.THREE
	]
	
	var weights = position_location_weights[receiver_position]
	
	var wc = WeightedChoice.new(options, weights)
	return wc.Pick()

func _determine_shot_type_iso() -> ShotGSE.SHOT_TYPE:
	return ShotGSE.SHOT_TYPE.LAYUP
