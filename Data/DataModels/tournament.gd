extends RefCounted
class_name Tournament
# single elimination bracket tournaments


var id: String
var conference: Conference = null
var year: int


var teams: Array[Team]  # must have a length that is a power of 2
var bracket: Array  # Array[Array[upper_seed, lower_seed]]
var games: Array[Game]
var champion: Team


var start_date: Timestamp
var game_days: Array[Array]  # [[round1_day, round1_day], [round2_day, round2_day], etc]

var num_teams: int
var num_rounds: int


static func New(tournament_id: String, conference_id: String, year: int, query: String, start: Timestamp, gd: Array[Array], seeding_col: String = "") -> Tournament:
	var t = Tournament.new()
	t.id = tournament_id
	if conference_id:
		t.conference = Conference.FromDatabase(conference_id)
	t.year = year
	
	# query teams
	#var q = Database.Get(query)
	#t.teams.assign(q.map(func(dict): return Team.FromDatabase(dict["ID"])))
	var teams_df = Database.GetDataFrame(query)
	print(teams_df)
	if seeding_col:
		teams_df.SortBy(seeding_col, true)
	t.teams.assign(
		teams_df.GetColumn("ID").map(func(team_id: String): return Team.FromDatabase(team_id))
	)
	
	t.start_date = start
	t.game_days = gd
	
	t.SetUpBracket()
	return t


static func FromDatabase(id: String) -> Tournament:
	var dict = Database.GetItem("Tournaments", id)
	return Tournament.FromDict(dict)


static func FromDatabaseByParams(conference_id: String, year: int) -> Tournament:
	var dict = Database.Get("SELECT * FROM Tournaments WHERE ConferenceID = '%s' AND Year = %d" % [conference_id, year])[0]
	return Tournament.FromDict(dict)


static func Exists(conference_id: String, year: int) -> bool:
	var result = Database.Get("SELECT * FROM Tournaments WHERE ConferenceID = '%s' AND Year = %d" % [conference_id, year])
	return len(result) > 0


static func FromDict(dict: Dictionary) -> Tournament:
	var t = Tournament.new()
	
	t.id = dict["ID"]
	t.conference = Conference.FromDatabase(dict["ConferenceID"]) if dict["ConferenceID"] else null
	t.year = dict["Year"]
	t.teams.assign(
		Array(dict["TeamIDs"].split(",")).map(func(team_id): return Team.FromDatabase(team_id))
	)
	t.games.assign(
		Array(
			dict["GameIDs"].split(",")).map(func(game_id): return Game.FromDatabase(int(game_id))
		) if dict["GameIDs"] else []
	)
	t.start_date = Timestamp.FromStr(dict["StartDate"])
	t.game_days.assign(
		str_to_var(dict["GameDays"])
	)
	t.SetUpBracket()
	
	if dict["Champion"]:
		t.champion = Team.FromDatabase(dict["Champion"])
	
	return t


func Activate():
	print("Activating tournament with teams: ", teams)
	_add_to_database()
	ScheduleGames(1)
	UpdateDatabase()


func ScheduleGames(round: int):  # note: rounds start at 1
	print(bracket)
	print("\tScheduling round %d games:" % round)
	
	var next_id = Database.GetValue("SELECT seq FROM sqlite_sequence WHERE name = 'Games'") + 1
	
	var to_schedule = bracket[round]
	var game_dict_list = []
	for pairing in to_schedule:
		var upper_seed = pairing[0]
		var lower_seed = pairing[1]
		var day_offset = game_days[round][randi() % len(game_days[round])]
		var g = {
			"ID": next_id,
			"Timestamp": start_date.Add(day_offset).ToISOStr(),
			"TournamentID": id,
			"Home": teams[upper_seed - 1].school.id,
			"Away": teams[lower_seed - 1].school.id
		}
		var game = Game._from_dict(g)
		print("\t\t", game)
		game_dict_list.append(g)
		games.append(game)
		next_id += 1
	
	Database.database.insert_rows("Games", game_dict_list)


func UpdateWithGameResults():
	print(teams)
	SetUpBracket()
	print(bracket)
	
	var r = 1
	for round in bracket.slice(1):
		for pairing: Array in round:
			if pairing[0] != 0 and pairing[1] != 0:  # if fully-described pairing
				print("\t", pairing)
				# if game doesn't exist yet, make it
				var home_id = teams[pairing[0]-1].id
				var away_id = teams[pairing[1]-1].id
				print("\t\t", home_id, " ", away_id)
				var matches = games.filter(func(g: Game): return true if g.home.id == home_id and g.away.id == away_id else false)
				print("\t\t", matches)
				assert(len(matches) <= 1)
				
				if len(matches) == 0:
					print("\t\tSchedule new game!")
					var next_id = Database.GetValue("SELECT seq FROM sqlite_sequence WHERE name = 'Games'") + 1
					var day_offset = game_days[r][randi() % len(game_days[r])]
					var g = {
						"ID": next_id,
						"Timestamp": start_date.Add(day_offset).ToISOStr(),
						"TournamentID": id,
						"Home": teams[pairing[0] - 1].school.id,
						"Away": teams[pairing[1] - 1].school.id
					}
					Database.InsertRow("Games", g)  # TODO: split this out into a common ScheduleGame() function
					
					var game = Game._from_dict(g)
					games.append(game)
		r += 1
	
	# add champion, if necessary
	if len(games) == len(teams) - 1:  # if all possible games exist
		var last_game = games[-1]
		if last_game.home_score:  # if championship game has been played
			champion = last_game.home if last_game.home_score >= last_game.away_score else last_game.away
	
	UpdateDatabase()


func SetUpBracket():
	num_teams = len(teams)
	num_rounds = int(log(num_teams)/log(2))
	bracket = []
	for r in num_rounds+1:
		if r == 0:
			bracket.append(null)
		else:
			bracket.append([])
	
	# calculate "chalk" paths (reverse walkthrough)
	for r in range(num_rounds, 0, -1):
		if r == num_rounds:
			bracket[r].append([1, 2])
		else:
			var next_round = bracket[r+1]
			var n_teams_this_round = 2 ** (num_rounds - r + 1)
			for pairing in next_round:
				for upper_seed in pairing:
					var prev_pair = [
						upper_seed,
						n_teams_this_round - upper_seed + 1
					]
					bracket[r].append(prev_pair)
	
	# adjust for results (forward walkthrough), remove unplayed seeds
	var game_ix = 0
	for r in range(2, num_rounds+1):
		var last_round = bracket[r-1]
		
		var num_games = num_teams / (2 ** r)  # games this round
		for i in num_games:
			var pairing = [0, 0]
			
			# get upper seed
			if game_ix < len(games):
				var upper_game = games[game_ix]
				var upper_pairing = bracket[r - 1][i * 2]
				if upper_game.home_score:
					var winner_seed = upper_pairing[0] if upper_game.home_score >= upper_game.away_score else upper_pairing[1]
					pairing[0] = winner_seed
			game_ix += 1
			
			# get lower seed
			if game_ix < len(games):
				var lower_game = games[game_ix]
				var lower_pairing = bracket[r - 1][(i * 2) + 1]
				if lower_game.home_score:
					var winner_seed = lower_pairing[0] if lower_game.home_score >= lower_game.away_score else lower_pairing[1]
					pairing[1] = winner_seed
			game_ix += 1
		
			bracket[r][i] = pairing


func _to_dict() -> Dictionary:
	var team_ids = teams.map(func(t): return t.id)
	var game_ids = games.map(func(g): return g.id)
	
	return {
		"ID": id,
		"ConferenceID": conference.id if conference else "",
		"Year": str(year),
		"StartDate": start_date.ToISOStr(),
		"GameDays": var_to_str(game_days),  # TODO: use this for other to_dicts throughout the codebase
		"TeamIDs": ",".join(team_ids),
		"GameIDs": ",".join(game_ids),
		"Champion": champion.id if champion else ""
	}


func _add_to_database():
	Database.InsertRow("Tournaments", _to_dict())

func UpdateDatabase():
	Database.UpdateRow("Tournaments", id, _to_dict())
