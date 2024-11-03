extends CanvasLayer
class_name UIManager


signal advance_time
signal game_results
signal user_game_complete(game: Game, result: GameResult)


@onready var EVENT_PAGES = [
	$PageManager/TestEvent,
	$PageManager/PracticeEvent,
	$PageManager/MeetingEvent,
	$PageManager/PressEvent,
	$PageManager/GameEvent
]
var current_event: CalendarEvent
var current_event_page: EventPage
var games_exist_today: bool


func Refresh(ag: ActiveGame, ce: CalendarEvent, g_e_t: bool):
	current_event = ce
	games_exist_today = g_e_t
	
	$TopBar/Time.text = ag.current_time.ToPrettyStr()
	
	if current_event and not ag.processed_events_yet:
		$TopBar/Games.hide()
		$TopBar/Event.show()
		$TopBar/Event.text = "Go To %s" % CalendarEvent.EVENT_TYPE.keys()[current_event.event_type]
		current_event_page = EVENT_PAGES[current_event.event_type]
	elif games_exist_today and not ag.simmed_games_yet:
		$TopBar/Event.hide()
		$TopBar/Games.show()
	else:
		$TopBar/Event.hide()
		$TopBar/Games.hide()
	
	for page in $PageManager.get_children():
		if page.visible and page.has_method("Refresh"):
			page.Refresh()


func Announce(title: String, content: Array[String]):
	$Announcement.Activate(title, content)


func OpenConferencePage(conf_id: String):
	$PageManager.RenderPage($PageManager/Conference, conf_id)

func OpenTeamPage(team_id: String):
	$PageManager.RenderPage($PageManager/Team, team_id)  # todo: pass multiple arguments, just use FromSchool


func _on_advance_pressed():
	advance_time.emit()

func _on_event_pressed():
	$PageManager.RenderEvent(current_event_page, current_event)

func _on_games_pressed():
	game_results.emit()
	$PageManager.RenderPage($PageManager/Schedule, "")
	$TopBar/Games.hide()

func _on_system_button_pressed():
	$PageManager.RenderPage($PageManager/System, "")


func _on_home_pressed():
	$PageManager.RenderHome()

func _on_team_pressed():
	var coach_id = Database.active_game.PLAYER_ID
	var coach = Coach.FromDatabase(coach_id)
	var school_id = coach.school_id
	var year = Database.active_game.current_time.year
	var team_id = Database.GetTeamFromSchool(school_id, year)["ID"]
	OpenTeamPage(team_id)

func _on_strategy_pressed():
	pass # Replace with function body.

func _on_schedule_pressed():
	var coach_id = Database.active_game.PLAYER_ID
	var coach = Coach.FromDatabase(coach_id)
	var school_id = coach.school_id
	$PageManager.RenderPage($PageManager/Schedule, school_id)

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


# todo: emit signal and do more of this logic in active_game (as with game_results)
func _on_event_completed(event_page: EventPage):
	$PageManager.CompleteEvent(event_page)
	Database.active_game.processed_events_yet = true
	if event_page is GameEventPage:
		user_game_complete.emit(event_page.game, event_page.result)
	
	$PageManager.RenderHome()
	Refresh(Database.active_game, null, games_exist_today)
	
	Database.active_game.SaveGame()
