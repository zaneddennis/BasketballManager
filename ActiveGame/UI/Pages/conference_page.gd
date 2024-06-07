extends Page


var conference: Conference


func Activate(id):
	super(id)
	conference = Conference.FromDatabase(id)
	
	$Content/VBoxContainer/Header/Label.text = conference.name
	
	$Content/VBoxContainer/Summary/StandingsWidget.Render(conference.id)


func _on_standings_widget_team_link(team_id):
	%UI.OpenTeamPage(team_id)
