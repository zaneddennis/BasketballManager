extends EventPage
class_name GameEventPage


@export var GSEDescriptionWidget: PackedScene


var game: Game
var in_progress: bool = false
var gs: GameSimulator
var result: GameResult

var tick_speed = 1.0  # ticks per second
const MIN_SPEED = 0.25
const MAX_SPEED = 4.0


func _ready():
	if get_tree().current_scene == self:
		var g = Game.New(
			Team.New(
				School.New(
					"BAY", "Baylor", "Bears"
				), [
					Player.New(
						Character.New("Jared", "Butler"), 75, 195,
						15, 9, 0,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					),
					Player.New(
						Character.New("Davion", "Mitchell"), 74, 205,
						16, 11, 0,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					),
					Player.New(
						Character.New("Macio", "Teague"), 76, 195,
						13, 7, 0,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					),
					Player.New(
						Character.New("Mark", "Vital"), 77, 250,
						0, 17, 0,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					),
					Player.New(
						Character.New("Flo", "Thamba"), 82, 245,
						0, 0, 15,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					),
					Player.New(
						Character.New("Adam", "Flagler"), 75, 180,
						0, 0, 0,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					),
					Player.New(
						Character.New("Jonathan", "Tchamwa Tchatchoua"), 80, 245,
						0, 0, 14,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					),
					Player.New(
						Character.New("Matthew", "Mayer"), 81, 225,
						0, 0, 0,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					)
				]
			),
			Team.New(
				School.New(
					"ZAGA", "Gonzaga", "Bulldogs"
				), [
					Player.New(
						Character.New("Jalen", "Suggs"), 76, 205,
						0, 0, 0,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					),
					Player.New(
						Character.New("Joel", "Ayayi"), 77, 180,
						0, 0, 0,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					),
					Player.New(
						Character.New("Andrew", "Nembhard"), 77, 195,
						0, 0, 0,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					),
					Player.New(
						Character.New("Corey", "Kispert"), 79, 220,
						0, 0, 0,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					),
					Player.New(
						Character.New("Drew", "Timme"), 82, 235,
						0, 0, 17,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					),
					Player.New(
						Character.New("Aaron", "Cook"), 73, 180,
						0, 0, 0,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					),
					Player.New(
						Character.New("Anton", "Watson"), 80, 225,
						0, 0, 0,
						0, 0, 0, 0, 0, 0,
						0, 0, 0
					)
				]
			)
		)
		ActivateDebug(g)
		
		# non-UI simulator
		var temp_gs = GameSimulator.new(g)
		var result = temp_gs.Simulate()
		print("SIMULATION RESULT: ", result)


func Activate(e: CalendarEventGame):
	if not in_progress:
		event = e
		
		var game_id = event.game_id
		game = Game.FromDatabase(game_id)
		
		gs = GameSimulator.new(game)
		
		ActivateUI()
		in_progress = true
	
	show()


func ActivateDebug(g: Game):
	game = g
	gs = GameSimulator.new(game)
	
	ActivateUI()
	in_progress = true


func ActivateUI():
	# static info
	$Content/VBoxContainer/Scoreboard/HBoxContainer/Home.text = game.home.school.id
	$Content/VBoxContainer/Scoreboard/HBoxContainer/Away.text = game.away.school.id
	$Content/VBoxContainer/HBoxContainer/Left/Team.text = game.home.school.short_name + " " + game.home.school.mascot
	$Content/VBoxContainer/HBoxContainer/Right/Team.text = game.away.school.short_name + " " + game.away.school.mascot
	
	# team panels
	ActivateTeamUI(game.home, $Content/VBoxContainer/HBoxContainer/Left)
	ActivateTeamUI(game.away, $Content/VBoxContainer/HBoxContainer/Right)
	
	# miscellaneous
	$Content/VBoxContainer/HBoxContainer/Center/Complete.hide()
	$Content/VBoxContainer/HBoxContainer/Center/Start.show()
	UpdateClock()
	UpdateScoreboard()


func ActivateTeamUI(t: Team, vbox: VBoxContainer):
	var widgets = []
	for n in vbox.get_children():
		if n is PlayerLiveBoxScoreWidget:
			widgets.append(n)
	
	var i = 0
	for widget: PlayerLiveBoxScoreWidget in widgets:
		if i < len(t.strategy.lineup):
			var p: Player = t.strategy.lineup[i]
			widget.Activate(i, p)
		else:
			widget.hide()
		i += 1


func Pause():
	$Timer.paused = true
	$Content/VBoxContainer/HBoxContainer/Center/TimeControls/Pause.text = ">"

func Resume():
	$Timer.paused = false
	$Content/VBoxContainer/HBoxContainer/Center/TimeControls/Pause.text = "||"


func UpdateClock():
	var time = gs.time
	var mm = time / 60
	var ss = time % 60
	$Content/VBoxContainer/Scoreboard/HBoxContainer/Clock.text = "%d:%02d" % [mm, ss]
	$Content/VBoxContainer/Scoreboard/HBoxContainer/Clock/Half.text = "%dH" % gs.half

func UpdateScoreboard():
	$Content/VBoxContainer/Scoreboard/HBoxContainer/HomeScore.text = "%02d" % gs.home_score
	$Content/VBoxContainer/Scoreboard/HBoxContainer/AwayScore.text = "%02d" % gs.away_score


func AddDescription(gse: GameSimulationEvent):
	var desc = GSEDescriptionWidget.instantiate()
	var time = gs.time + gse.time_elapsed
	var mm = time / 60
	var ss = time % 60
	desc.text = "[%d:%02d] %s" % [mm, ss, gse.description]
	$Content/VBoxContainer/HBoxContainer/Center/Queue/VBoxContainer.add_child(desc)
	$Content/VBoxContainer/HBoxContainer/Center/Queue/VBoxContainer.move_child(desc, 0)


func Halftime():
	$Content/VBoxContainer/HBoxContainer/Center/TimeControls.hide()
	$Content/VBoxContainer/HBoxContainer/Center/Halftime.show()

func EndGame():
	$Content/VBoxContainer/HBoxContainer/Center/TimeControls.hide()
	$Content/VBoxContainer/HBoxContainer/Center/Complete.show()


func _on_start_pressed():
	$Content/VBoxContainer/HBoxContainer/Center/Start.hide()
	$Content/VBoxContainer/HBoxContainer/Center/TimeControls.show()
	
	UpdateClock()
	$Timer.start()

func _on_halftime_pressed():  # to end halftime
	$Content/VBoxContainer/HBoxContainer/Center/Halftime.hide()
	$Content/VBoxContainer/HBoxContainer/Center/TimeControls.show()
	
	gs.StartHalf(2)
	UpdateClock()
	$Timer.start()

func _on_complete_pressed():
	result = gs.CompileResult()
	event_completed.emit(self)


func _on_timer_timeout():
	var gse = gs.Tick()
	
	if gse is EndOfHalfGSE:
		if gs.half == 1:
			Halftime()
		elif gs.half == 2:
			EndGame()
		else:
			assert(false)
	
	else:
		$Timer.start(1.0 / tick_speed)
	
	AddDescription(gse)
	UpdateClock()
	UpdateScoreboard()


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
