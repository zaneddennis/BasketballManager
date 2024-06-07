extends "res://ActiveGame/UI/Pages/page.gd"


var team: Team


func Activate(id):
	assert(id)
	super(id)
	
	team = Team.FromDatabase(id)
	
	$Content/VBoxContainer/Header/VBoxContainer/Title.text = "%d %s %s" % [team.year, team.school.short_name, team.school.mascot]
	$Content/VBoxContainer/Header/VBoxContainer/Record.text = "0 - 0 (0 - 0 %s)" % team.school.conference.id
	
	ClearTabs()
	ActivateSummary()


func ClearTabs():
	for n in [$Content/VBoxContainer/Summary, $Content/VBoxContainer/Roster, $Content/VBoxContainer/Schedule, $Content/VBoxContainer/Stats]:
		n.hide()

func ActivateSummary():
	var hc_character = Character.FromDatabase(team.head_coach.character_id)
	$Content/VBoxContainer/Summary/Miscellaneous/Coaches/VBoxContainer/Head.right = hc_character.FullName()
	
	$Content/VBoxContainer/Summary/Schedule/Last5/VBoxContainer/Table.data = DataFrame.New(
		[
			["ABC", "W", "69", "-", "68"],
			["DEF", "L", "62", "-", "75"],
			["GHI", "W", "80", "-", "68"]
		],
		["Opp", "Result", "", "Score", ""]
	)
	$Content/VBoxContainer/Summary/Schedule/Last5/VBoxContainer/Table.Render()
	
	$Content/VBoxContainer/Summary.show()


func ActivateRoster():
	$Content/VBoxContainer/Roster/HBoxContainer/Players/Table.data = DataFrame.PlayersTable(team.players)
	$Content/VBoxContainer/Roster/HBoxContainer/Players/Table.Render()
	
	$Content/VBoxContainer/Roster.show()


func ActivateRosterPlayer(player_ix: int):
	var player = team.players[player_ix]
	$Content/VBoxContainer/Roster/HBoxContainer/PlayerDetails/Bio/VBoxContainer/Panel/HBoxContainer/Label.text = player.GetCharacter().FullName()
	$Content/VBoxContainer/Roster/HBoxContainer/PlayerDetails/Bio/VBoxContainer/Physical.text = \
	" %d AGL | %d STR | %d VER" % [player.agility, player.strength, player.vertical_reach]
	$Content/VBoxContainer/Roster/HBoxContainer/PlayerDetails/Bio/VBoxContainer/Technical.text = \
	" %d HND | %d FIN | %d SHO | %d REB | %d PER | %d INT" % [
		player.ball_handling, player.finishing, player.shooting, player.rebounding, player.perimeter_defense, player.interior_defense
	]
	$Content/VBoxContainer/Roster/HBoxContainer/PlayerDetails/Bio/VBoxContainer/Mental.text = \
	" %d VIS | %d OFF | %d POS" % [
		player.vision, player.off_the_ball, player.positioning
	]


func _on_summary_pressed():
	ClearTabs()
	ActivateSummary()

func _on_roster_pressed():
	ClearTabs()
	ActivateRoster()

func _on_schedule_pressed():
	ClearTabs()
	$Content/VBoxContainer/Schedule.show()

func _on_stats_pressed():
	ClearTabs()
	$Content/VBoxContainer/Stats.show()


func _on_table_row_hovered(row_id: int):
	ActivateRosterPlayer(row_id)
