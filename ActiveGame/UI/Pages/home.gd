extends Control


func Activate():
	show()
	
	var coach_id = Database.active_game.PLAYER_ID
	var coach = Coach.FromDatabase(coach_id)
	var school_id = coach.school_id
	var conference = Database.GetSchool(school_id)["Conference"]
	$HBoxContainer/ContentLeft/StandingsWidget.Render(conference)
	
	$HBoxContainer/ContentCenter/Calendar.Render(Database.active_game.current_time)


func Refresh():
	Activate()


func _on_standings_widget_team_link(team_id: int):
	%UI.OpenTeamPage(team_id)

func _on_standings_widget_conference_link(conference_id: String):
	%UI.OpenConferencePage(conference_id)