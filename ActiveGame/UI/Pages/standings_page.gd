extends "res://ActiveGame/UI/Pages/page.gd"


var StandingsWidgetScene = preload("res://ActiveGame/UI/Widgets/standings_widget.tscn")


#var school_id: String TODO


func Activate(id: Variant = null):
	#school_id = id
	super(id)
	
	for n in $Content/ScrollContainer/GridContainer.get_children():
		n.queue_free()
	
	var conferences_list = Database.GetColumnAsList("Conferences", "ID", "Prestige DESC")
	for conference_id: String in conferences_list:
		var widget: StandingsWidget = StandingsWidgetScene.instantiate()
		$Content/ScrollContainer/GridContainer.add_child(widget)
		widget.size_flags_horizontal = SIZE_EXPAND | SIZE_SHRINK_CENTER
		widget.Render(conference_id)
		
		if not widget.team_link.is_connected(_on_standings_widget_team_link):
			widget.team_link.connect(_on_standings_widget_team_link)
		if not widget.conference_link.is_connected(_on_standings_widget_conference_link):
			widget.conference_link.connect(_on_standings_widget_conference_link)


func Refresh():
	super()
	
	Activate()


func _on_standings_widget_team_link(team_id: String):
	%UI.OpenTeamPage(team_id)

func _on_standings_widget_conference_link(conference_id: String):
	%UI.OpenConferencePage(conference_id)
