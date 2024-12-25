extends EventPage
class_name GameEventPage


@export var GSEDescriptionWidget: PackedScene


signal name_hovered


var game: Game
var in_progress: bool = false
var gs: GameSimulator
var result: GameResult

var tick_speed = 1.0  # ticks per second
const MIN_SPEED = 0.25
const MAX_SPEED = 4.0


func _ready():
	if get_tree().current_scene == self:
		var baylor = School.New(
					"BAY", "Baylor", "Bears"
				)
		var zaga = School.New(
					"ZAGA", "Gonzaga", "Bulldogs"
				)
		
		var g = Game.New(
			Team.New(
				baylor, [
					Player.New(
						Character.New("Jared", "Butler"), 0, 75, 195,
						14, 9, 6,
						14, 16, 17, 10, 16, 8,
						15, 18, 16, baylor
					),
					Player.New(
						Character.New("Davion", "Mitchell"), 1, 74, 205,
						16, 11, 7,
						13, 14, 15, 11, 19, 12,
						13, 15, 16, baylor
					),
					Player.New(
						Character.New("Macio", "Teague"), 2, 76, 195,
						14, 7, 8,
						13, 12, 16, 8, 12, 8,
						12, 17, 12, baylor
					),
					Player.New(
						Character.New("Mark", "Vital"), 3, 77, 250,
						12, 17, 10,
						6, 9, 5, 18, 11, 16,
						8, 7, 15, baylor
					),
					Player.New(
						Character.New("Flo", "Thamba"), 4, 82, 245,
						9, 12, 15,
						4, 7, 5, 13, 6, 12,
						3, 6, 10, baylor
					),
					Player.New(
						Character.New("Adam", "Flagler"), 5, 75, 180,
						13, 6, 7,
						14, 13, 14, 8, 11, 6,
						12, 17, 12, baylor
					),
					Player.New(
						Character.New("Jonathan", "Tchamwa Tchatchoua"), 6, 80, 245,
						11, 12, 14,
						5, 12, 6, 13, 7, 14,
						6, 8, 10, baylor
					),
					Player.New(
						Character.New("Matthew", "Mayer"), 7, 81, 225,
						8, 11, 13,
						9, 11, 12, 11, 8, 8,
						7, 10, 10, baylor
					)
				]
			),
			Team.New(
				zaga, [
					Player.New(
						Character.New("Jalen", "Suggs"), 8, 76, 205,
						18, 7, 8,
						17, 15, 13, 12, 10, 7,
						14, 9, 8, zaga
					),
					Player.New(
						Character.New("Joel", "Ayayi"), 9, 77, 180,
						14, 5, 8,
						13, 13, 12, 10, 10, 10,
						10, 10, 10, zaga
					),
					Player.New(
						Character.New("Andrew", "Nembhard"), 10, 77, 195,
						15, 7, 9,
						14, 10, 14, 10, 10, 10,
						10, 12, 10, zaga
					),
					Player.New(
						Character.New("Corey", "Kispert"), 11, 79, 220,
						10, 11, 13,
						10, 12, 16, 10, 9, 12,
						6, 13, 9, zaga
					),
					Player.New(
						Character.New("Drew", "Timme"), 12, 82, 235,
						6, 11, 17,
						5, 15, 7, 14, 5, 11,
						7, 9, 12, zaga
					),
					Player.New(
						Character.New("Aaron", "Cook"), 13, 73, 180,
						13, 4, 6,
						11, 10, 10, 10, 8, 8,
						8, 8, 8, zaga
					),
					Player.New(
						Character.New("Anton", "Watson"), 14, 80, 225,
						9, 12, 13,
						6, 12, 6, 10, 6, 8,
						8, 8, 8, zaga
					)
				]
			)
		)
		ActivateDebug(g)
		
		# non-UI simulator
		print("---")
		var temp_gs = GameSimulator.new(g)
		var result = temp_gs.Simulate()
		print("SIMULATION RESULT: ", result)


func Activate(e: CalendarEventGame):
	print("Activating CalendarEventGame")
	if not in_progress:
		event = e
		
		var game_id = event.game_id
		game = Game.FromDatabase(game_id)
		print("\t", game)
		
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
	for n in $Content/VBoxContainer/HBoxContainer/Center/Queue/VBoxContainer.get_children():
		n.queue_free()
	
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
			if not widget.name_hovered.is_connected(_on_hover_player_name):
				widget.name_hovered.connect(_on_hover_player_name)
			
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

func UpdatePlayers():
	for vbox in [$Content/VBoxContainer/HBoxContainer/Left, $Content/VBoxContainer/HBoxContainer/Right]:
		for n in vbox.get_children():
			if n is PlayerLiveBoxScoreWidget and n.visible:
				n.Refresh(gs.player_stats[n.player.id])


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
	in_progress = false
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
	UpdatePlayers()


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


func _on_hover_player_name(pos: Vector2, pla: Player):
	name_hovered.emit(pos, pla)
