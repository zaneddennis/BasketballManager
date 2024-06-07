extends "res://ActiveGame/UI/Pages/page.gd"


var school_id: String  # why is this here???


func Activate(id):
	school_id = id
	super(id)
	
	for widget: StandingsWidget in $Content/ScrollContainer/GridContainer.get_children():
		widget.Render()
		
		if not widget.team_link.is_connected(_on_standings_widget_team_link):
			widget.team_link.connect(_on_standings_widget_team_link)
		if not widget.conference_link.is_connected(_on_standings_widget_conference_link):
			widget.conference_link.connect(_on_standings_widget_conference_link)

func Refresh():
	super()
	
	Activate(school_id)


func _on_standings_widget_team_link(team_id: int):
	%UI.OpenTeamPage(team_id)

func _on_standings_widget_conference_link(conference_id: String):
	%UI.OpenConferencePage(conference_id)
