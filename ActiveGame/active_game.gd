extends Node
class_name ActiveGame


@onready var ui: UIManager = $UI
@onready var page_manager: PageManager = $UI/PageManager

var slot: String

var current_time: Timestamp
var processed_events_yet: bool = false
var simmed_games_yet: bool = false
const PLAYER_ID: int = 1  # todo: change these to "user" for consistency
var player_school_id: String


func _ready():
	var seed = randi()
	print("Random seed: ", seed)
	seed(seed)
	
	if TransitionManager.slot:
		print("Loading Game: ", TransitionManager.slot)
		slot = TransitionManager.slot
	else:
		print("Loading Game From Debug: ", Constants.DEBUG_SAVE)
		slot = Constants.DEBUG_SAVE
	
	LoadFromSlot(slot)
	
	Database.active_game = self
	Database.Activate(slot)
	
	player_school_id = Database.GetItem("Coaches", PLAYER_ID)["SchoolID"]
	
	if TransitionManager.first_time_load:
		NewSeason()
	
	page_manager.RenderHome()

	NewDay(true)


func LoadFromSlot(slot: String):
	var filepath_partial = Constants.SAVES_LOCATION + "/" + slot
	
	var save_meta_dict = JSON.parse_string(
			FileAccess.open(filepath_partial + "/meta.json", FileAccess.READ).get_as_text()
		)
	#player_id = save_meta_dict["player_id"]
	
	var game_status_dict = JSON.parse_string(
		FileAccess.open(filepath_partial + "/game_status.json", FileAccess.READ).get_as_text()
	)
	current_time = Timestamp.FromStr(game_status_dict["current_time"])
	processed_events_yet = game_status_dict["processed_events_yet"]
	simmed_games_yet = game_status_dict["simmed_games_yet"]


func RecordGameResult(result: GameResult, game: Game):
	print("Recording Game Result: ", game.home, game.away)
	var winner = ""
	var loser = ""
	if result.home_score >= result.away_score:
		winner = game.home.school.id
		loser = game.away.school.id
	else:
		winner = game.away.school.id
		loser = game.home.school.id
	
	Database.database.update_rows(
		"Games", "ID = %d" % game.id, {
			"HomeScore": result.home_score,
			"AwayScore": result.away_score
		}
	)
	var s = Database.database.query("""
		UPDATE Teams
		SET Wins = Wins + 1
		WHERE ID = '%s%d'
	""" % [winner, current_time.year])
	print("Winner query success: ", s)
	Database.database.query("""
		UPDATE Teams
		SET Losses = Losses + 1
		WHERE ID = '%s%d'
	""" % [loser, current_time.year])
	print("Loser query success: ", s)


func NewSeason():
	print("New Season!")
	
	# create new Teams
	var school_ids = Database.GetColumnAsList("Schools", "ID", "ID")
	var rows = []
	for i in range(len(school_ids)):
		var school_id = school_ids[i]
		var player_ids = Database.GetColumnAsList("Players", "ID", "ID", "SchoolID = '%s'" % school_id)
		var coach_id = Database.Get("SELECT ID FROM Coaches WHERE SchoolID = '%s'" % school_id)[0]["ID"]
		rows.append(
			{"ID": school_id + str(current_time.year), "SchoolID": school_id, "Year": current_time.year, "Wins": 0, "Losses": 0, "HeadCoach": coach_id, "Players": str(player_ids)}
		)
	var s = Database.database.insert_rows("Teams", rows)
	if not s:
		print("\tError creating new teams: ", Database.database.error_message)
	
	# schedule Games
	print("Scheduling Games...")
	var conference_list = Database.GetColumnAsList("Conferences", "ID", "ID")
	var next_id = Database.GetValue("SELECT COUNT(ID) FROM Games") + 1
	
	print("\t", "Generating Noncon Games")
	var games = GameScheduler.GenerateNonconSchedule(next_id)
	for conference_id in conference_list:
		next_id = games[len(games) - 1]["ID"] + 1
		print("\t", "Generating %s Games" % conference_id)
		games += GameScheduler.GenerateConferenceSchedule(conference_id, next_id)
	
	for game in games:
		print("\t", game)
	s = Database.database.insert_rows("Games", games)
	if not s:
		print("\tError creating new games: ", Database.database.error_message)


func ConcludeRegularSeason():
	var conferences = Database.GetColumnAsList("Conferences", "ID", "ID")
	var content: Array[String] = []
	for conf in conferences:
		var standings_df = Database.GetConferenceStandings(conf)
		var champion = standings_df.GetRow(0)
		print("%s Champion: " % conf, champion)
		content.append("%s Champion: %s" % [conf, champion[0]])
		
	ui.Announce(
		"202X CONFERENCE CHAMPIONS:",
		content
	)


func NewPhase():
	if current_time.phase == Timestamp.PHASE.CONFERENCE_TOURNAMENT:
		ConcludeRegularSeason()


func ConcludeDay():
	var schools_list = Database.GetColumnAsList("Schools", "ID", "ID")
	for school_id in schools_list:
		var event = CalendarEventScheduler.Schedule(current_time, school_id)
		print("\t", school_id, " ", event)


func NewDay(loading: bool = false):
	if not loading:
		processed_events_yet = false
		simmed_games_yet = false
	
	var user_event_today = null
	if not processed_events_yet:
		user_event_today = CalendarEventScheduler.Schedule(current_time, player_school_id)
	var games_today = []
	if not simmed_games_yet:
		games_today = Database.Get("SELECT * FROM Games WHERE Timestamp = '%s'" % current_time.ToISOStr())
	print(current_time)
	print("\tUser: ", user_event_today)
	print("\tGames: ", games_today)
	ui.Refresh(self, user_event_today, len(games_today) > 0)


# updates meta.json and game_status.json
func SaveGame():
	var filepath_partial = Constants.SAVES_LOCATION + "/" + slot
	
	var meta_file = FileAccess.open(filepath_partial + "/meta.json", FileAccess.READ)
	var meta_dict = JSON.parse_string(meta_file.get_as_text())
	meta_dict["last_played"] = Time.get_date_string_from_system()
	meta_file = FileAccess.open(filepath_partial + "/meta.json", FileAccess.WRITE)
	meta_file.store_string(JSON.stringify(meta_dict, "\t", false))
	
	var gs_file = FileAccess.open(filepath_partial + "/game_status.json", FileAccess.READ)
	var gs_dict = JSON.parse_string(gs_file.get_as_text())
	gs_dict["current_time"] = current_time.ToISOStr()
	gs_dict["processed_events_yet"] = processed_events_yet
	gs_dict["simmed_games_yet"] = simmed_games_yet
	gs_file = FileAccess.open(filepath_partial + "/game_status.json", FileAccess.WRITE)
	gs_file.store_string(JSON.stringify(gs_dict, "\t", false))


func _on_complete_user_game(game: Game, result: GameResult):
	RecordGameResult(result, game)


# when going to Game Results screen for the day, simulate all unplayed games
func _on_ui_game_results():
	var games = Database.Get("SELECT * FROM Games WHERE Timestamp = '%s'" % current_time.ToISOStr())
	for game_dict in games:
		if not player_school_id in [game_dict["Home"], game_dict["Away"]]:
			var gs = GameSimulator.new(Game.FromDatabase(game_dict["ID"]))  # TODO: make sure this works
			var result = gs.Simulate()
			RecordGameResult(result, Game.FromDatabase(game_dict["ID"]))
	simmed_games_yet = true
	SaveGame()


func _on_ui_advance_time():
	ConcludeDay()
	
	var new_things = current_time.Advance()
	if "season" in new_things:
		NewSeason()
	if "phase" in new_things:
		NewPhase()
	
	SaveGame()
	NewDay()
	$UI/PageManager.RenderHome()
