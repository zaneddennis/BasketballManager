extends Page


var school_id: String


func Activate(id: Variant = null):
	if id:
		school_id = id
	else:
		school_id = ""
	super(id)
	
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


func SetTeamSchedule(school_id: String):
	var df = Database.GetDataFrame("""
		SELECT Timestamp, ID, Home, COALESCE(HomeScore, ''), '-', COALESCE(AwayScore, ''), Away
		FROM Games
		WHERE (Home = '%s' OR Away = '%s') AND Timestamp >= '%d-0-0-0'
		ORDER BY Timestamp
	""" % [school_id, school_id, Database.active_game.current_time.year])
	df.columns = ["Date", "GameID", "Home", "", "", "", "Away"]
	$Content/VBoxContainer/Team/Schedule/Table.data = df
	df.MapToColumn("Date", func(ts): return "W%s: %s" % [ts.split("-")[2], Timestamp.DAY.keys()[int(ts.split("-")[3])].capitalize()])
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


func SetGameDetails(game_id: int):
	pass



func _on_table_row_hovered(row_id):
	var game_id = $Content/VBoxContainer/Team/Schedule/Table.data.GetValue(row_id, "GameID")
	SetGameDetails(game_id)


func _on_team_select_item_selected(index):
	var school_id = $Content/VBoxContainer/Team/Schedule/Controls/TeamSelect.get_selected_metadata()
	self.school_id = school_id
	SetTeamSchedule(school_id)

func _on_day_select_day_selected(index):
	var date = $Content/VBoxContainer/Daily/Schedule/Controls/DaySelect.get_selected_metadata()
	SetDailySchedule(date)


func _on_team_tab_pressed():
	ActivateTeam()


func _on_daily_tab_pressed():
	ActivateDaily()
