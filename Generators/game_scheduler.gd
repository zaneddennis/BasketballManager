extends RefCounted
class_name GameScheduler


# density targets: 2.0 games/week in-conference, ??? OOC?

const MAX_CONF_DRR_SIZE = 11  # maximum number of teams that can do a double round robin schedule

const CONF_START = 6  # week of regular season that conference play starts
const REG_GAMEDAYS = [0, 2, 5]  # Monday, Wednesday, Saturday

const MIN_NONCON_COUNT = 4
const MAX_NONCON_COUNT = 6
const MAX_CONF_COUNT = 20


static func GenerateConferenceSchedule(conference_id: String, next_game_id: int) -> Array[Dictionary]:
	var games = AttemptGenerateConferenceSchedule(conference_id, next_game_id)
	while not games:
		games = AttemptGenerateConferenceSchedule(conference_id, next_game_id)
	return games


static func AttemptGenerateConferenceSchedule(conference_id: String, next_game_id: int):
	var teams = Database.GetColumnAsList("Schools", "ID", "ID", "Conference = '%s'" % conference_id)
	
	if len(teams) <= MAX_CONF_DRR_SIZE:
		return AttemptGenerateConferenceScheduleDRR(teams, next_game_id, conference_id)
	else:
		return AttemptGenerateConferenceScheduleMixed(teams, next_game_id, conference_id)


static func AttemptGenerateConferenceScheduleDRR(teams: Array, next_game_id: int, conference_id: String) -> Array[Dictionary]:  # list of games
	print("\t\tAttempting DRR...")
	#var teams = Database.GetColumnAsList("Schools", "ID", "ID", "Conference = '%s'" % conference_id)
	
	var games_needed = []
	for a in range(len(teams)):
		var team_a = teams[a]
		for b in range(a + 1, len(teams)):
			var team_b = teams[b]
			games_needed.append([team_a, team_b])
			games_needed.append([team_b, team_a])
	print("\t\t\t%d total games needed for %d teams (%d per team)" % [len(games_needed), len(teams), 2 * (len(teams) - 1)])
	
	var num_weeks = Timestamp.PHASE_LENGTHS[Timestamp.PHASE.REGULAR_SEASON] - CONF_START
	var num_slots = num_weeks * len(REG_GAMEDAYS)
	print("\t\t\t%d slots in %d weeks per team" % [num_slots, num_weeks])
	
	var slots = {}
	for t in teams:
		slots[t] = []
		for s in num_slots:
			slots[t].append(s)
	
	var games: Array[Dictionary] = []
	var id = next_game_id
	for game in games_needed:
		var valid_slots = []
		for s in slots[game[0]]:
			if s in slots[game[1]]:
				valid_slots.append(s)
		
		if not valid_slots:
			return []
		
		var slot = valid_slots.pick_random()
		slots[game[0]].erase(slot)
		slots[game[1]].erase(slot)
		
		var slot_timestamp = "%d-%d-%d-%d" % [Database.active_game.current_time.year, Timestamp.PHASE.REGULAR_SEASON, CONF_START + (slot / 3), REG_GAMEDAYS[slot % 3]]
		games.append(
			{"ID": id, "Timestamp": slot_timestamp, "ConferenceID": conference_id, "Home": game[0], "Away": game[1]}
		)
		id += 1
	
	return games

static func AttemptGenerateConferenceScheduleMixed(teams: Array, next_game_id: int, conference_id: String) -> Array[Dictionary]:
	print("\tAttempting Mixed...")
	
	var games_needed = []
	
	# pick double-opponents
	var num_doubles = MAX_CONF_COUNT - len(teams) + 1
	var double_opponents = {}
	for team in teams:
		double_opponents[team] = []
	
	for team in teams:
		print("\t\t", team, double_opponents[team])
		while len(double_opponents[team]) < num_doubles:
			var valid_opps = teams.filter(func(t): return len(double_opponents[t]) < num_doubles and t != team and not t in double_opponents[team])
			if not valid_opps:
				return []
			var opp = valid_opps.pick_random()
			print("\t\t\t", opp)
			double_opponents[team].append(opp)
			double_opponents[opp].append(team)
	
	for t1 in range(len(teams)):
		for t2 in range(t1+1, len(teams)):
			var team = teams[t1]
			var opp = teams[t2]
			if opp in double_opponents[team]:
				games_needed.append([team, opp])
				games_needed.append([opp, team])
			else:
				if randf() < 0.5:
					games_needed.append([team, opp])
				else:
					games_needed.append([opp, team])
	
	print("\t\t\t%d total games needed for %d teams (%d per team)" % [len(games_needed), len(teams), MAX_CONF_COUNT])
	
	var num_weeks = Timestamp.PHASE_LENGTHS[Timestamp.PHASE.REGULAR_SEASON] - CONF_START
	var num_slots = num_weeks * len(REG_GAMEDAYS)
	print("\t\t\t%d slots in %d weeks per team" % [num_slots, num_weeks])
	
	var slots = {}
	for t in teams:
		slots[t] = []
		for s in num_slots:
			slots[t].append(s)
	
	var games: Array[Dictionary] = []
	var id = next_game_id
	for game in games_needed:
		var valid_slots = []
		for s in slots[game[0]]:
			if s in slots[game[1]]:
				valid_slots.append(s)
		
		if not valid_slots:
			return []
		
		var slot = valid_slots.pick_random()
		slots[game[0]].erase(slot)
		slots[game[1]].erase(slot)
	
		var slot_timestamp = "%d-%d-%d-%d" % [Database.active_game.current_time.year, Timestamp.PHASE.REGULAR_SEASON, CONF_START + (slot / 3), REG_GAMEDAYS[slot % 3]]
		games.append(
			{"ID": id, "Timestamp": slot_timestamp, "ConferenceID": conference_id, "Home": game[0], "Away": game[1]}
		)
		id += 1

	return games


static func GenerateNonconSchedule(next_game_id: int) -> Array[Dictionary]:
	var games = AttemptGenerateNonconSchedule(next_game_id)
	while not games:
		games = AttemptGenerateNonconSchedule(next_game_id)
	return games
	

static func AttemptGenerateNonconSchedule(next_game_id: int) -> Array[Dictionary]:
	print("\t\tAttempting...")
	var teams_list = Database.GetColumnAsList("Schools", "ID", "ID")
	var conferences_list = Database.GetColumnAsList("Schools", "Conference", "ID")
	
	var counts = {}
	var conferences = {}
	for t in len(teams_list):
		counts[teams_list[t]] = 0
		conferences[teams_list[t]] = conferences_list[t]
	
	var games_needed = []
	var teams_shuffled = teams_list.duplicate()
	teams_shuffled.shuffle()
	for team in teams_shuffled:
		while counts[team] < MIN_NONCON_COUNT:
			var candidates = []
			for other in teams_list:
				if counts[other] < MAX_NONCON_COUNT and conferences[other] != conferences[team]:
					candidates.append(other)
			
			if candidates.is_empty():
				return []
			
			var opp = candidates.pick_random()
			if randf() < 0.5:
				games_needed.append([team, opp])
			else:
				games_needed.append([opp, team])
			
			counts[team] += 1
			counts[opp] += 1
	
	print("\t\t\t%d total games needed for %d teams (%d - %d per team)" % [len(games_needed), len(teams_list), MIN_NONCON_COUNT, MAX_NONCON_COUNT])
	
	var num_weeks = CONF_START - 1
	#var num_slots = num_weeks * 3
	var num_slots = num_weeks * len(REG_GAMEDAYS)
	print("\t\t\t%d slots in %d weeks per team" % [num_slots, num_weeks])
	
	var slots = {}
	for team in teams_list:
		slots[team] = []
		for s in num_slots:
			slots[team].append(s)
	
	var games: Array[Dictionary] = []
	var id = next_game_id
	for game in games_needed:
		var valid_slots = []
		for s in slots[game[0]]:
			if s in slots[game[1]]:
				valid_slots.append(s)
		
		if not valid_slots:
			return []
		
		var slot = valid_slots.pick_random()
		slots[game[0]].erase(slot)
		slots[game[1]].erase(slot)
		
		var slot_timestamp = "%d-%d-%d-%d" % [Database.active_game.current_time.year, Timestamp.PHASE.REGULAR_SEASON, slot / 3, REG_GAMEDAYS[slot % 3]]
		games.append(
			{"ID": id, "Timestamp": slot_timestamp, "Home": game[0], "Away": game[1]}
		)
		id += 1
	
	return games
