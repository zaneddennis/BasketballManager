extends EventPage
class_name GameEventPage


var game: Game
var in_progress: bool = false
var gs: GameSimulator
var result: GameResult

var tick_speed = 1.0  # ticks per second
const MIN_SPEED = 0.25
const MAX_SPEED = 4.0

# todo: separate GameSimulator object that handles game status and logic and this node just visualizes it
var time = 0


func Activate(e: CalendarEventGame):
	if not in_progress:
		event = e
		gs = GameSimulator.new()
		
		var game_id = event.game_id
		game = Game.FromDatabase(game_id)
		
		$Content/VBoxContainer/Scoreboard/HBoxContainer/Home.text = game.home.school.id
		$Content/VBoxContainer/Scoreboard/HBoxContainer/Away.text = game.away.school.id
		$Content/VBoxContainer/HBoxContainer/Left/Team.text = game.home.school.short_name + " " + game.home.school.mascot
		$Content/VBoxContainer/HBoxContainer/Right/Team.text = game.away.school.short_name + " " + game.away.school.mascot
		
		$Content/VBoxContainer/HBoxContainer/Center/Complete.hide()
		$Content/VBoxContainer/HBoxContainer/Center/Start.show()
		
		time = 1200
		UpdateClock()
		
		in_progress = true
	
	show()


func Pause():
	$Timer.paused = true
	$Content/VBoxContainer/HBoxContainer/Center/TimeControls/Pause.text = ">"

func Resume():
	$Timer.paused = false
	$Content/VBoxContainer/HBoxContainer/Center/TimeControls/Pause.text = "||"


func UpdateClock():
	var mm = time / 60
	var ss = time % 60
	$Content/VBoxContainer/Scoreboard/HBoxContainer/Clock.text = "%d:%02d" % [mm, ss]


func _on_start_pressed():
	$Content/VBoxContainer/HBoxContainer/Center/Start.hide()
	$Content/VBoxContainer/HBoxContainer/Center/TimeControls.show()
	
	UpdateClock()
	$Timer.start()

func _on_complete_pressed():
	event_completed.emit(self)


# todo: Tick() function
func _on_timer_timeout():
	time -= 30
	
	if time <= 0:
		time = 0
	UpdateClock()
	
	$Timer.start(1.0 / tick_speed)
	
	if time == 0:
		$Timer.stop()
		result = gs.Simulate()
		$Content/VBoxContainer/HBoxContainer/Center/Complete.show()


func _on_pause_pressed():
	if $Timer.paused:
		Resume()
	else:
		Pause()

func _on_faster_pressed():
	if tick_speed < MAX_SPEED:
		tick_speed += 0.25

func _on_slower_pressed():
	if tick_speed > MIN_SPEED:
		tick_speed -= 0.25
