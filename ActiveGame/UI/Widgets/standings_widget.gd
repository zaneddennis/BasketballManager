extends Panel
class_name StandingsWidget


signal team_link(team_id: String)
signal conference_link(conference_id: String)


@export var override_title: String = ""
@export var default_conference_id: String = ""
var conference: Conference


func Render(c: String = ""):
	var conference_id = default_conference_id
	if c:
		conference_id = c
	
	conference = Conference.FromDatabase(conference_id)
	var df = Database.GetConferenceStandings(conference.id)
	
	var title_text = conference.short_name
	if override_title:
		title_text = override_title
	$VBoxContainer/Title.text = "[url]%s[/url]" % title_text
	
	$VBoxContainer/Table.data = df
	$VBoxContainer/Table.Render({"Team": "url"})
	if not $VBoxContainer/Table.cell_clicked.is_connected(_on_table_cell_clicked):
		$VBoxContainer/Table.cell_clicked.connect(_on_table_cell_clicked)

func _on_table_cell_clicked(meta):
	var school_id = str(meta)
	var year = Database.active_game.current_time.year
	var team_id = Database.GetTeamFromSchool(school_id, year)["ID"]
	team_link.emit(team_id)


func _on_title_meta_clicked(meta):
	conference_link.emit(conference.id)
