extends RefCounted
class_name GameScheduler


const CONF_START = 4  # week of regular season that conference play starts
const REG_GAMEDAYS = [0, 2, 5]  # Monday, Wednesday, Saturday


static func GenerateConferenceSchedule(conference_id: String, next_game_id: int) -> Array[Dictionary]:  # list of games
	var teams = Database.GetColumnAsList("Schools", "ID", "ID", "Conference = '%s'" % conference_id)
	
	var games_needed = []
	for a in range(len(teams)):
		var team_a = teams[a]
		for b in range(a + 1, len(teams)):
			var team_b = teams[b]
			games_needed.append([team_a, team_b])
			games_needed.append([team_b, team_a])
	
	var num_weeks = Timestamp.PHASE_LENGTHS[Timestamp.PHASE.REGULAR_SEASON] - CONF_START
	var num_slots = num_weeks * 3
	
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
		
		var slot = valid_slots.pick_random()
		slots[game[0]].erase(slot)
		slots[game[1]].erase(slot)
		
		var slot_timestamp = "%d-%d-%d-%d" % [Database.active_game.current_time.year, Timestamp.PHASE.REGULAR_SEASON, CONF_START + (slot / 3), REG_GAMEDAYS[slot % 3]]
		games.append(
			{"ID": id, "Timestamp": slot_timestamp, "Home": game[0], "Away": game[1]}
		)
		id += 1
	
	return games


static func GenerateNonconSchedule(next_game_id: int) -> Array[Dictionary]:
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
		while counts[team] < 4:
			var candidates = []
			for other in teams_list:
				if counts[other] < 5 and conferences[other] != conferences[team]:
					candidates.append(other)
			
			var opp = candidates.pick_random()
			if randf() < 0.5:
				games_needed.append([team, opp])
			else:
				games_needed.append([opp, team])
			
			counts[team] += 1
			counts[opp] += 1
	
	var num_weeks = CONF_START - 1
	var num_slots = num_weeks * 3
	
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
		
		var slot = valid_slots.pick_random()
		slots[game[0]].erase(slot)
		slots[game[1]].erase(slot)
		
		var slot_timestamp = "%d-%d-%d-%d" % [Database.active_game.current_time.year, Timestamp.PHASE.REGULAR_SEASON, slot / 3, REG_GAMEDAYS[slot % 3]]
		games.append(
			{"ID": id, "Timestamp": slot_timestamp, "Home": game[0], "Away": game[1]}
		)
		id += 1
	
	return games
