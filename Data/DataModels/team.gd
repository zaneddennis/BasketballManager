extends Object
class_name Team


var id: String
var school: School
var year: int

var wins: int = 0
var losses: int = 0

var head_coach: Coach
var players: Array[Player]
var strategy: Strategy


# assumes p Array is given in lineup order
static func New(s: School, p: Array[Player], st: Strategy = null) -> Team:
	var t = Team.new()
	
	t.school = s
	t.players = p
	if st:
		t.strategy = st
	else:
		t.strategy = Strategy.New(
			t.players, []
		)
	
	return t


static func FromDatabase(team_id: String) -> Team:
	var dict = Database.GetItem("Teams", team_id)
	return _from_dict(dict)


func DecideStrategy():
	print("\tSetting Team Strategy")
	
	var new_lineup: Array[Player]
	var new_roles: Array[PlayerRole]
	
	var new_lineup_d = {}
	
	var scores = {}
	var all_scores = {}
	var by_player = {}
	for pos in ["PG", "SG", "SF", "PF", "C"]:
		scores[pos] = {}
		all_scores[pos] = {}
		for p: Player in players:
			if not p.id in by_player:
				by_player[p.id] = {}
			if not p.id in all_scores[pos]:
				all_scores[pos][p.id] = {}
			
			var best_score = -1
			for role: PlayerRole in Database.player_roles.values():
				if pos in role.valid_positions:
					var val = head_coach.philosophy.evaluator.EvaluatePlayer(p, role, head_coach)
					all_scores[pos][p.id][role.get_unique_id()] = val
					if val > best_score:
						best_score = val
			by_player[p.id][pos] = best_score
			scores[pos][p.id] = best_score
	
	for pos in ["PG", "SG", "SF", "PF", "C"]:
		#print(pos)
		var pos_dict = scores[pos]
		for p_id in new_lineup_d.values():
			pos_dict.erase(p_id)
		
		#print(pos_dict)
		var best_id = pos_dict.keys()[pos_dict.values().find(pos_dict.values().max())]
		new_lineup_d[pos] = best_id
		#print(new_lineup_d)
	
	#print(by_player)
	var next_pos = 6
	while len(new_lineup_d) < 12:
		# find best overall remaining player
		var best_score = -1
		var best_id = -1
		for p_id in by_player:
			if not p_id in new_lineup_d.values():
				var player_best = by_player[p_id].values().max()
				if player_best > best_score:
					best_score = player_best
					best_id = p_id
		
		# add them to next spot
		new_lineup_d[str(next_pos)] = best_id
		next_pos += 1
	
	#print(all_scores)
	#print(new_lineup_d)
	
	new_lineup = []
	new_roles = []
	for pos in new_lineup_d:
		var player_id = new_lineup_d[pos]
		new_lineup.append(players.filter(func(player): return player.id == player_id)[0])
		
		var player_dict
		if pos in ["PG", "SG", "SF", "PF", "C"]:
			player_dict = all_scores[pos][player_id]
		else:
			player_dict = all_scores["PG"][player_id].merged(all_scores["SG"][player_id]).merged(all_scores["SF"][player_id]).merged(all_scores["PF"][player_id]).merged(all_scores["C"][player_id])
		#print(pos, player_dict)
		var role_id = player_dict.keys()[player_dict.values().find(player_dict.values().max())]
		new_roles.append(Database.player_roles[role_id])
	
	print("\t\t", new_lineup)
	print("\t\t", new_roles)
	print("---")
	var new_strategy = Strategy.New(new_lineup, new_roles)
	
	# save back to DB
	strategy = new_strategy
	UpdateDatabase()


func UpdateDatabase():
	Database.UpdateRow(
		"Teams", id,
		ToDict(true)
	)


static func _from_dict(dict: Dictionary) -> Team:
	var t = Team.new()
	
	t.id = dict["ID"]
	var school_id = dict["SchoolID"]
	t.school = School.FromDatabase(school_id)
	t.year = dict["Year"]
	
	t.wins = dict["Wins"]
	t.losses = dict["Losses"]
	
	var coach_id = dict["HeadCoach"]
	t.head_coach = Coach.FromDatabase(coach_id)
	
	var player_ids = dict["Players"].split(",")
	var players: Array[Player] = []
	for p_id in player_ids:
		players.append(Player.FromDatabase(int(p_id)))
	t.players = players
	
	t.strategy = Strategy.FromDict(JSON.parse_string(dict["Strategy"]))
	
	return t


func ToDict(strify: bool = false) -> Dictionary:
	var d = {}
	
	d["ID"] = id
	d["SchoolID"] = school.id
	d["Year"] = year
	
	d["Wins"] = wins
	d["Losses"] = losses
	
	d["HeadCoach"] = head_coach.id
	d["Players"] = players.map(func(p: Player): return p.id)
	if strify:
		d["Players"] = str(d["Players"])
	d["Strategy"] = strategy.ToDict()
	if strify:
		d["Strategy"] = str(d["Strategy"])
	
	print(d)
	return d


func _to_string():
	return "<Team:%s:%s:%d>" % [id, school.id, year]
