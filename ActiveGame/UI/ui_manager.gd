extends CanvasLayer
class_name UIManager

signal advance_time


@onready var EVENT_PAGES = [
	$PageManager/TestEvent,
	$PageManager/PracticeEvent,
	$PageManager/TestEvent,
	$PageManager/PressEvent,
	$PageManager/GameEvent
]
var current_event: CalendarEvent
var current_event_page: EventPage


func Refresh(ag: ActiveGame):
	$TopBar/Time.text = ag.current_time.ToPrettyStr()
	
	# check for Event at current time
	current_event = $PageManager/Home/HBoxContainer/ContentCenter/Calendar.GetEventAtTime(ag.current_time)
	if current_event:
		$TopBar/Event.show()
		$TopBar/Event.text = "Go To %s" % CalendarEvent.EVENT_TYPE.keys()[current_event.event_type]
		current_event_page = EVENT_PAGES[current_event.event_type]
	else:
		$TopBar/Event.hide()
	
	for page in $PageManager.get_children():
		if page.visible and page.has_method("Refresh"):
			page.Refresh()


func OpenConferencePage(conf_id: String):
	$PageManager.RenderPage($PageManager/Conference, conf_id)

func OpenTeamPage(team_id: int):
	$PageManager.RenderPage($PageManager/Team, team_id)  # todo: pass multiple arguments, just use FromSchool


func _on_advance_pressed():
	advance_time.emit()

func _on_event_pressed():
	$PageManager.RenderEvent(current_event_page, current_event)

func _on_system_button_pressed():
	$PageManager.RenderPage($PageManager/System, "")


func _on_home_pressed():
	$PageManager.RenderHome()

func _on_team_pressed():
	var coach_id = Database.active_game.player_id
	var coach = Coach.FromDatabase(coach_id)
	var school_id = coach.school_id
	var year = Database.active_game.current_time.year
	var team_id = Database.GetTeamFromSchool(school_id, year)["ID"]
	OpenTeamPage(team_id)

func _on_standings_pressed():
	$PageManager.RenderPage($PageManager/Standings, "")

func _on_school_pressed():
	var coach_id = Database.active_game.PLAYER_ID
	var coach = Coach.FromDatabase(coach_id)
	var school_id = coach.school_id
	if school_id:
		$PageManager.RenderPage($PageManager/School, school_id)

func _on_profile_pressed():
	$PageManager.RenderPage($PageManager/Character, Database.active_game.PLAYER_ID)


func _on_event_completed(event_page: EventPage):
	$PageManager.CompleteEvent(event_page)
	$PageManager.RenderHome()
	$TopBar/Event.hide()
