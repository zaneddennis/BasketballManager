extends Page


var school_id: String
var conference_id: String
var year: int


func Activate(id: Variant = null):
	if id:
		school_id = id
		var school = School.FromDatabase(school_id)
		conference_id = school.conference.id
	else:
		school_id = ""
	super(id)
	
	year = Database.active_game.current_time.year
	
	var school_names = Database.GetColumnAsList("Schools", "ShortName", "ShortName")
	var school_ids = Database.GetColumnAsList("Schools", "ID", "ShortName")
	$Content/VBoxContainer/Team/Schedule/Controls/TeamSelect.Activate(school_names, school_ids)
	if school_id:
		$Content/VBoxContainer/Team/Schedule/Controls/TeamSelect.SelectOptionByMeta(school_id)
	
	var dates = []
	var timestamps = []
	var date = Database.active_game.current_time.Copy()
	for w in range(Timestamp.PHASE_LENGTHS[Timestamp.PHASE.REGULAR_SEASON]):
		for d in [0, 2, 5]:
			var day = Timestamp.DAY.keys()[d].capitalize()
			dates.append("W%d: %s" % [w, day])
			timestamps.append(Timestamp.new(date.year, Timestamp.PHASE.REGULAR_SEASON, w, d))
	$Content/VBoxContainer/Daily/Schedule/Controls/DaySelect.Activate(dates, timestamps)
	while not date.phase == Timestamp.PHASE.REGULAR_SEASON or not date.day in [Timestamp.DAY.MONDAY, Timestamp.DAY.WEDNESDAY, Timestamp.DAY.SATURDAY]:
		date.Advance()
	$Content/VBoxContainer/Daily/Schedule/Controls/DaySelect.SelectOption("W%d: %s" % [date.week, date.DayName()])
	
	var all_years = Database.Get(
		"SELECT DISTINCT Year FROM Tournaments"
	).map(func(d): return str(d["Year"]))
	var all_conferences = Database.Get(
		"SELECT DISTINCT ConferenceID FROM Tournaments WHERE ConferenceID != ''"
	).map(func(d): return d["ConferenceID"])
	$Content/VBoxContainer/ConferenceTournament/Left/Controls/Year.Activate(all_years)
	$Content/VBoxContainer/NationalTournament/Left/Controls/Year.Activate(all_years)
	$Content/VBoxContainer/ConferenceTournament/Left/Controls/Conference.Activate(all_conferences)
	if school_id and len(all_conferences) > 0:
		# don't do this if no tournaments have happened before
		$Content/VBoxContainer/ConferenceTournament/Left/Controls/Conference.SelectOption(conference_id)
	
	if school_id:
		$Content/VBoxContainer/Tabs/Team.button_pressed = true
		ActivateTeam()
	else:
		ActivateDaily()


func ClearTabs():
	for t in $Content/VBoxContainer.get_children():
		if t.name != "Tabs":
			t.hide()


func ActivateTeam():
	ClearTabs()
	SetTeamSchedule(school_id)
	$Content/VBoxContainer/Team.show()

func ActivateDaily():
	ClearTabs()
	var date = Database.active_game.current_time.Copy()
	while not date.phase == Timestamp.PHASE.REGULAR_SEASON or not date.day in [Timestamp.DAY.MONDAY, Timestamp.DAY.WEDNESDAY, Timestamp.DAY.SATURDAY]:
		date.Advance()
	SetDailySchedule(date)
	$Content/VBoxContainer/Daily.show()

func ActivateConf():
	ClearTabs()
	SetConferenceTournament(conference_id, year)
	$Content/VBoxContainer/ConferenceTournament.show()

func ActivateNat():
	ClearTabs()
	SetNationalTournament(year)
	$Content/VBoxContainer/NationalTournament.show()


func SetTeamSchedule(school_id: String):
	var df = Database.GetDataFrame("""
		SELECT Timestamp, ID, Home, COALESCE(HomeScore, ''), '-', COALESCE(AwayScore, ''), Away, SUBSTR(Timestamp, 8, 4)
		FROM Games
		WHERE (Home = '%s' OR Away = '%s') AND Timestamp >= '%d-0-0-0'
		ORDER BY Timestamp
	""" % [school_id, school_id, Database.active_game.current_time.year])
	df.columns = ["Date", "GameID", "Home", "", "", "", "Away", "Week_Day"]
	df.MapToColumn("Week_Day", func(w_d): return int(w_d.split("-")[0]) * 7 + int(w_d.split("-")[1]))
	df.MapToColumn("Date", func(ts): return "W%s: %s" % [ts.split("-")[2], Timestamp.DAY.keys()[int(ts.split("-")[3])].capitalize()])
	df.SortBy("Week_Day")
	df.RemoveColumn("Week_Day")
	$Content/VBoxContainer/Team/Schedule/Table.data = df
	$Content/VBoxContainer/Team/Schedule/Table.Render()


func SetDailySchedule(date: Timestamp):
	var df = Database.GetDataFrame("""
		SELECT Timestamp, ID, Home, COALESCE(HomeScore, ''), '-', COALESCE(AwayScore, ''), Away
		FROM Games
		WHERE Timestamp = '%s'
	""" % date.ToISOStr())
	df.columns = ["Date", "GameID", "Home", "", "", "", "Away"]
	$Content/VBoxContainer/Daily/Schedule/Table.data = df
	$Content/VBoxContainer/Daily/Schedule/Table.Render()


func SetConferenceTournament(conf_id: String, year: int):
	if Tournament.Exists(conf_id, year):
		var t = Tournament.FromDatabaseByParams(conf_id, year)
		$Content/VBoxContainer/ConferenceTournament/Left/BracketWidget.tournament = t
		$Content/VBoxContainer/ConferenceTournament/Left/BracketWidget.Render(true)
	else:
		$Content/VBoxContainer/ConferenceTournament/Left/BracketWidget.tournament = null
		$Content/VBoxContainer/ConferenceTournament/Left/BracketWidget.Render(false)

func SetNationalTournament(year: int):
	if Tournament.Exists("", year):
		var t = Tournament.FromDatabaseByParams("", year)
		$Content/VBoxContainer/NationalTournament/Left/BracketWidget.tournament = t
		$Content/VBoxContainer/NationalTournament/Left/BracketWidget.Render(true)
	else:
		$Content/VBoxContainer/NationalTournament/Left/BracketWidget.tournament = null
		$Content/VBoxContainer/NationalTournament/Left/BracketWidget.Render(false)


func SetGameDetails(game_id: int):
	pass



func _on_table_row_hovered(row_id):
	var game_id = $Content/VBoxContainer/Team/Schedule/Table.data.GetValue(row_id, "GameID")
	SetGameDetails(game_id)


# Team Schedule
func _on_team_select_item_selected(index):
	var school_id = $Content/VBoxContainer/Team/Schedule/Controls/TeamSelect.get_selected_metadata()
	self.school_id = school_id
	SetTeamSchedule(school_id)

# Daily Schedule
func _on_day_select_day_selected(index):
	var date = $Content/VBoxContainer/Daily/Schedule/Controls/DaySelect.get_selected_metadata()
	SetDailySchedule(date)

# Conference Tournament
func _on_conference_tournament_conference_selected(index):
	conference_id = $Content/VBoxContainer/ConferenceTournament/Left/Controls/Conference.GetSelectedOption()
	SetConferenceTournament(conference_id, year)

func _on_conference_tournament_year_selected(index):
	year = int($Content/VBoxContainer/ConferenceTournament/Left/Controls/Year.GetSelectedOption())
	SetConferenceTournament(conference_id, year)

func _on_national_tournament_year_selected(index):
	year = int($Content/VBoxContainer/NationalTournament/Left/Controls/Year.GetSelectedOption())
	SetNationalTournament(year)


func _on_team_tab_pressed():
	ActivateTeam()

func _on_daily_tab_pressed():
	ActivateDaily()

func _on_conf_tourney_tab_pressed():
	ActivateConf()

func _on_nat_tourney_tab_pressed():
	ActivateNat()
