extends GameSimulationEvent
class_name HalfcourtGSEv2


var openness: Array[float]  # ~N(0)

var planned_movements_from: Array[CourtLocation]
var planned_movements_to: Array[CourtLocation]
var planned_pass_from: Player
var planned_pass_to: Player


func _init(gs: GameSimulator, config: Dictionary = {}):
	super(gs, config)
	
	team = gs.possession
	openness = config["openness"]  # how open everyone is as result of last GSE ~N(0) TODO: strategy aggression modifier
	planned_movements_from = []
	planned_movements_to = []

	Simulatev3(gs)


func Simulatev3(gs: GameSimulator):
	#print("Simulate halfcourt offense")
	description = "%s - Halfcourt Offense" % GetTeamID()
	
	var player_process_order: Array[Player] = [gs.GetBallHandlingPlayer()]
	player_process_order += offense_players
	player_process_order.remove_at(player_process_order.rfind(gs.GetBallHandlingPlayer()))
	
	var i = 0
	var actions = []
	for player: Player in player_process_order:  # offensive players
		#print(player)
		var ix = offense_players.find(player)
		
		# what is my status?
		var loc: CourtLocation = gs.player_locs[player.id]
		var is_ballhander = (i == 0)
		#if is_ballhander:
			#print("\tballhandler")
		#print("\t", loc)
		var my_openness = openness[ix]
		
		# what are my possible options from here?
		var options = GetPlayerOptions(player, loc, is_ballhander)  # [String]
		
		# set priorities for each option
		var role: PlayerRole
		if gs.possession == gs.TEAM.HOME:  # TODO: move this into base GSE setup?
			role = gs.game.home.strategy.roles[ix]
		else:
			role = gs.game.away.strategy.roles[ix]
		
		var priorities = {}  # {String: float > 0}
		for option: String in options:
			priorities[option] = GetOptionPriority(option, gs, player, role, my_openness)
		#print("\tPriorities [%s]: " % role.get_unique_id(), priorities)
		
		# pick option
		var highest_prio = priorities.values().max()
		var action = priorities.find_key(highest_prio)
		actions.append(action)
		#print("\t", actions[-1])
		
		i += 1
	
	# execute actions
	for j in range(5):
		var player = player_process_order[j]
		#print(player)
		var defender = defense_players[offense_players.find(player)]
		#print("\t", defender)
		var action = actions[j]
		#print("\t", action)
		
		ExecutePlayerAction(gs, player, defender, action)
	
	time_elapsed = randi_range(2, 8)


func GetPlayerOptions(player: Player, loc: CourtLocation, has_ball: bool) -> Array:
	if has_ball:
		return ["shoot", "perimeter_dribble", "drive", "pass_0", "pass_1", "pass_2", "pass_3", "pass_4"]
	else:
		return ["set_up", "post_up", "interior_cut"]


func GetOptionPriority(option: String, gs: GameSimulator, player: Player, role: PlayerRole, my_openness: float) -> float:
	var base = 1.0
	var minimum = 0.001  # to ensure there is never no option to pick
	#var multiplier = 1.0
	
	var situation_prio = 0.0
	match option:
		"shoot":
			situation_prio += my_openness
			if gs.player_locs[player.id].area == CourtLocation.AREA.VALVE:  # TODO: make this tabular for all areas
				situation_prio -= 0.9
			if gs.player_locs[player.id].area in [CourtLocation.AREA.BLOCK, CourtLocation.AREA.FLAT, CourtLocation.AREA.FT_LINE]:
				situation_prio += 0.5
		"perimeter_dribble":
			minimum = 0.25
			if gs.player_locs[player.id].area == CourtLocation.AREA.VALVE:
				situation_prio += 2.0
			elif gs.player_locs[player.id].area in [CourtLocation.AREA.BLOCK]:
				situation_prio -= 0.5
		"drive":
			if not gs.player_locs[player.id].area in [CourtLocation.AREA.PERIMETER, CourtLocation.AREA.CORNER, CourtLocation.AREA.ELBOW]:
				situation_prio -= 1.0
	
	if "pass" in option:
		var recipient_ix = int(option.split("_")[-1])
		var recipient: Player = offense_players[recipient_ix]
		
		if recipient == player:
			return 0.0
		else:
			situation_prio += openness[recipient_ix]
		
		option = "pass"
		#multiplier = 0.25  # to balance for there being 4 passing sub-options
	
	var role_prio = role.get("prio_" + option)  # TODO: different types of shots, e.g. Slashers like Layups and Off Ball Shooters like Threes
	
	var vision_val = 1.0 - (player.vision / 20.0)
	var vision_adj = randfn(0.0, vision_val)
	return max(minimum, base + situation_prio + role_prio + vision_adj)


# TODO: split these out into functions
func ExecutePlayerAction(gs: GameSimulator, player: Player, defender: Player, action: String):
	var current_loc = gs.player_locs[player.id]
	var action_adj = action
	if "pass" in action:
		action_adj = action.split("_")[0]
	
	match action_adj:
		# with ball
		"shoot":
			# set and config next GSE: shotGSE
			player_locs[player.id] = gs.player_locs[player.id]
			player_locs[defender.id] = gs.player_locs[defender.id]
			player_staminas[player.id] = 0.005
			player_staminas[defender.id] = 0.005
			next = ShotGSE
			next_config = {
				"shooter": player,
				"defender": defender,
				"shot_type": CourtLocation.SHOT_TYPES[player_locs[player.id].area]
			}
		"perimeter_dribble":
			var open_locs = gs.GetOpenLocations(
				current_loc.half,
				[CourtLocation.AREA.PERIMETER]
			)
			
			# if perimeter spot available, go there
			# else, stay in place
			var new_loc = player_locs[player.id]
			var old_loc = new_loc
			if open_locs:
				new_loc = open_locs.pick_random()
			
			var off_roll = GameSimulator.Roll(player, {"ball_handling": 1.0}, 0.5)
			var def_roll = GameSimulator.Roll(
				defender,
				{"perimeter_defense": 1.0},
				0.5
			)
			var contest = off_roll - def_roll
			#print(contest)
			
			if off_roll - def_roll > -1.5:
				# success
				if new_loc != old_loc:
					planned_movements_from.append(gs.player_locs[player.id])
				gs.player_locs[player.id] = new_loc
				gs.player_locs[defender.id] = CourtLocation.new(new_loc.half, new_loc.area, new_loc.side, 1.0 + contest)
				planned_movements_to.append(new_loc)
				
				openness[offense_players.find(player)] = 1.0 + contest
				next = HalfcourtGSEv2
				next_config["openness"] = openness
			else:
				# fail (steal)
				description += " - STEAL"
				var statline = Statline.new()
				statline.steals = 1
				player_deltas[defender.id] = statline
				Turnover()
				gs.SetBallhandler(defender)
				next = TransitionGSE
				next_config = {
					"is_after_made": false,
					"is_fast_break": false  # TODO: make this a fast break once that's implemented
				}
				player_staminas[player.id] = 0.001
				player_staminas[defender.id] = 0.001
		
		"drive":
			var open_locs = gs.GetOpenLocations(
				current_loc.half,
				[CourtLocation.AREA.FT_LINE, CourtLocation.AREA.BLOCK]
			)
			
			var off_roll = GameSimulator.Roll(player, {"ball_handling": 1.0, "agility": 1.0}, 0.5)
			var def_roll = GameSimulator.Roll(
				defender,
				{"perimeter_defense": 1.0, "agility": 0.5},
				0.5
			)
			var contest = off_roll - def_roll
			
			var new_loc = player_locs[player.id]
			var old_loc = new_loc
			if open_locs and contest > 0:
				new_loc = open_locs.pick_random()  # TODO: prioritize locations
			
			if new_loc != old_loc and contest > 0:
				description += " - %s drives" % player.character.last
				planned_movements_from.append(gs.player_locs[player.id])
			else:
				description += " - %s attempts drive" % player.character.last
			gs.player_locs[player.id] = new_loc
			gs.player_locs[defender.id] = CourtLocation.new(new_loc.half, new_loc.area, new_loc.side, contest)
			planned_movements_to.append(new_loc)
			openness[offense_players.find(player)] = contest
			
			if contest < 0.0:
				description += " - STEAL by %s" % defender.character.last
				var statline = Statline.new()
				statline.steals = 1
				player_deltas[defender.id] = statline
				Turnover()
				gs.SetBallhandler(defender)
				next = TransitionGSE
				next_config = {
					"is_after_made": false,
					"is_fast_break": false  # TODO: make this a fast break once that's implemented
				}
			else:
				next = HalfcourtGSEv2
				next_config["openness"] = openness
			player_staminas[player.id] = 0.01
			player_staminas[defender.id] = 0.01
		
		"pass":
			var recipient_ix = int(action.split("_")[-1])
			var recipient: Player = offense_players[recipient_ix]
			
			gs.SetBallhandler(recipient)
			description += " - %s pass to %s" % [player.character.last, recipient.character.last]
			next = HalfcourtGSEv2
			next_config["openness"] = openness
		
		# without ball
		"set_up":
			if current_loc.area in [CourtLocation.AREA.PERIMETER, CourtLocation.AREA.CORNER]:
				player_locs[player.id] = gs.player_locs[player.id]
				player_locs[defender.id] = gs.player_locs[defender.id]
			else:
				var open_locs = gs.GetOpenLocations(
					current_loc.half,
					[CourtLocation.AREA.PERIMETER, CourtLocation.AREA.CORNER],
					planned_movements_from,
					planned_movements_to
				)
				var distances = open_locs.map(func(loc): return loc.GetPosition().distance_to(current_loc.GetPosition()))
				var new_loc = open_locs[distances.find(distances.min())]
				var old_loc = gs.player_locs[player.id]
				
				if not old_loc.Equals(new_loc):
					planned_movements_from.append(player_locs[player.id])
				player_locs[player.id] = new_loc
				player_locs[defender.id] = CourtLocation.new(new_loc.half, new_loc.area, new_loc.side, 1.0)
				planned_movements_to.append(new_loc)
			openness[offense_players.find(player)] = 0.0
		"post_up":
			if current_loc.IsPost():
				player_locs[player.id] = gs.player_locs[player.id]
				player_locs[defender.id] = gs.player_locs[defender.id]
			else:
				var open_locs = gs.GetOpenLocations(
					current_loc.half,
					[CourtLocation.AREA.BLOCK, CourtLocation.AREA.FT_LINE],
					planned_movements_from,
					planned_movements_to
				)
				var distances = open_locs.map(func(loc): return loc.GetPosition().distance_to(current_loc.GetPosition()))
				var new_loc = open_locs[distances.find(distances.min())]
				var old_loc = gs.player_locs[player.id]
				
				if not old_loc.Equals(new_loc):
					planned_movements_from.append(player_locs[player.id])
				player_locs[player.id] = new_loc
				player_locs[defender.id] = CourtLocation.new(new_loc.half, new_loc.area, new_loc.side, 0.0)
				planned_movements_to.append(new_loc)
			
			var offense = gs.Roll(player, {"strength": 1.0}, 0.25)
			var defense = gs.Roll(defender, {"strength": 1.0}, 0.25)
			openness[offense_players.find(player)] = offense - defense
			player_staminas[player.id] = 0.01
			player_staminas[defender.id] = 0.01
		
		"interior_cut":
			var open_locs = gs.GetOpenLocations(
					current_loc.half,
					[CourtLocation.AREA.BLOCK, CourtLocation.AREA.FT_LINE, CourtLocation.AREA.FLAT],
					planned_movements_from,
					planned_movements_to
			)
			var old_loc = gs.player_locs[player.id]
			var new_loc = open_locs.pick_random()
			
			planned_movements_from.append(old_loc)
			planned_movements_to.append(new_loc)
			
			var off_roll = GameSimulator.Roll(player, {"off_the_ball": 1.0, "strength": 0.25, "agility": 0.5}, 0.5)
			var def_roll = GameSimulator.Roll(defender, {"positioning": 1.0, "strength": 0.25, "agility": 0.5}, 0.5)
			#openness[offense_players.find(player)] = off_roll - def_roll
			var contest = off_roll - def_roll
			openness[offense_players.find(player)] = contest
			
			player_locs[player.id] = new_loc
			player_locs[defender.id] = CourtLocation.new(new_loc.half, new_loc.area, new_loc.side, contest)
			player_staminas[player.id] = 0.005
			player_staminas[defender.id] = 0.005
