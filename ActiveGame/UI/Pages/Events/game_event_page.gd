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
		Database.Create("_debug")
		Database.Activate("_debug")
		
		var baylor = School.New(
					"BAY", "Baylor", "Bears",
					Color("#154734"), Color("#FFB81C")
				)
		var zaga = School.New(
					"ZAGA", "Gonzaga", "Bulldogs",
					Color("#041E42"), Color("#C8102E")
				)
		
		var baylor_players: Array[Player] = []
		baylor_players.assign([
			Player.New(
				Character.New("Jared", "Butler"), 0, 12, 75, 195,
				14, 9, 6, 10,
				14, 10, 16, 17, 10, 16, 8,
				15, 18, 16, baylor
			),
			Player.New(
				Character.New("Davion", "Mitchell"), 1, 45, 74, 205,
				16, 11, 7, 10,
				13, 10, 14, 15, 11, 19, 12,
				13, 15, 16, baylor
			),
			Player.New(
				Character.New("Macio", "Teague"), 2, 31, 76, 195,
				14, 7, 8, 10,
				13, 10, 12, 16, 8, 12, 8,
				12, 17, 12, baylor
			),
			Player.New(
				Character.New("Mark", "Vital"), 3, 11, 77, 250,
				12, 17, 10, 10,
				6, 10, 9, 5, 18, 11, 16,
				8, 7, 15, baylor
			),
			Player.New(
				Character.New("Flo", "Thamba"), 4, 0, 82, 245,
				9, 12, 15, 10,
				4, 10, 7, 5, 13, 6, 12,
				3, 6, 10, baylor
			),
			Player.New(
				Character.New("Adam", "Flagler"), 5, 10, 75, 180,
				13, 6, 7, 10,
				14, 10, 13, 14, 8, 11, 6,
				12, 17, 12, baylor
			),
			Player.New(
				Character.New("Jonathan", "Tchamwa Tchatchoua"), 6, 23, 80, 245,
				11, 12, 14, 10,
				5, 10, 12, 6, 13, 7, 14,
				6, 8, 10, baylor
			),
			Player.New(
				Character.New("Matthew", "Mayer"), 7, 24, 81, 225,
				8, 11, 13, 10,
				9, 10, 11, 12, 11, 8, 8,
				7, 10, 10, baylor
			)
		])
		
		var zaga_players: Array[Player] = []
		zaga_players.assign([
			Player.New(
				Character.New("Jalen", "Suggs"), 8, 1, 76, 205,
				18, 7, 8, 10,
				17, 10, 15, 13, 12, 10, 7,
				14, 9, 8, zaga
			),
			Player.New(
				Character.New("Joel", "Ayayi"), 9, 11, 77, 180,
				14, 5, 8, 10,
				13, 10, 13, 12, 10, 10, 10,
				10, 10, 10, zaga
			),
			Player.New(
				Character.New("Andrew", "Nembhard"), 10, 3, 77, 195,
				15, 7, 9, 10,
				14, 10, 10, 14, 10, 10, 10,
				10, 12, 10, zaga
			),
			Player.New(
				Character.New("Corey", "Kispert"), 11, 24, 79, 220,
				10, 11, 13, 10,
				10, 10, 12, 16, 10, 9, 12,
				6, 13, 9, zaga
			),
			Player.New(
				Character.New("Drew", "Timme"), 12, 2, 82, 235,
				6, 11, 17, 10,
				5, 10, 15, 7, 14, 5, 11,
				7, 9, 12, zaga
			),
			Player.New(
				Character.New("Aaron", "Cook"), 13, 10, 73, 180,
				13, 4, 6, 10,
				11, 10, 10, 10, 10, 8, 8,
				8, 8, 8, zaga
			),
			Player.New(
				Character.New("Anton", "Watson"), 14, 22, 80, 225,
				9, 12, 13, 10,
				6, 10, 12, 6, 10, 6, 8,
				8, 8, 8, zaga
			)
		])
		
		var baylor_roles: Array[PlayerRole] = []
		var role_ids = ["creator", "combo_guard", "off_ball_shooter", "rebounder", "rebounder",
						"rebounder", "rebounder", "rebounder", "rebounder", "rebounder",
						"rebounder", "rebounder"]
		baylor_roles.assign(role_ids.map(func(rid): return Database.player_roles[rid]))
		#baylor_roles.assign(["creator", "combo_guard", "off_ball_shooter", "rebounder", "rebounder"].map(func(rid): return Database.player_roles[rid]))
		var baylor_strat = Strategy.New(
			baylor_players,
			baylor_roles
		)
		
		var zaga_roles: Array[PlayerRole] = []
		role_ids = ["creator", "combo_guard", "combo_guard", "stretch_big", "rebounder",
					"rebounder", "rebounder", "rebounder", "rebounder", "rebounder",
					"rebounder", "rebounder"]
		zaga_roles.assign(role_ids.map(func(rid): return Database.player_roles[rid]))
		var zaga_strat = Strategy.New(
			zaga_players,
			zaga_roles
		)
		
		var baylor_team = Team.New(baylor, baylor_players, baylor_strat)
		var zaga_team = Team.New(zaga, zaga_players, zaga_strat)
		
		var g = Game.New(baylor_team, zaga_team)
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
	
	# court
	var player_icons = $Content/VBoxContainer/HBoxContainer/Center/Court/SubViewportContainer/SubViewport.get_children()
	for i in range(5):
		player_icons[i].Activate(gs.home_active_lineup[i])
	for i in range(5):
		player_icons[5+i].Activate(gs.away_active_lineup[i])
	
	# queue
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
			var r: PlayerRole = t.strategy.roles[i]
			widget.Activate(i, p, r)
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


func RenderGSE(gse: GameSimulationEvent):
	for i in range(5):
		var ocpi: OnCourtPlayerInstance = $Content/VBoxContainer/HBoxContainer/Center/Court/SubViewportContainer/SubViewport.get_child(i)
		var player = gs.home_active_lineup[i]
		ocpi.Update(gs.player_locs[player.id])
	for i in range(5):
		var ocpi: OnCourtPlayerInstance = $Content/VBoxContainer/HBoxContainer/Center/Court/SubViewportContainer/SubViewport.get_child(5 + i)
		var player = gs.away_active_lineup[i]
		ocpi.Update(gs.player_locs[player.id])
	
	var ball = $Content/VBoxContainer/HBoxContainer/Center/Court/SubViewportContainer/SubViewport/Ball
	if gs.ball_handler_ix != -1:
		var ball_handler_ix = gs.ball_handler_ix
		var player_instance = $Content/VBoxContainer/HBoxContainer/Center/Court/SubViewportContainer/SubViewport.get_child(ball_handler_ix)
		ball.position = player_instance.position + Vector2(0, 16)
	else:
		ball.position = CourtLocation.BASKET_LOC[gs.ball_half] + gs.ball_pos * (-1 ** gs.ball_half)
	
	if gse is ShotGSE:
		var shooter_ix = (gs.home_active_lineup + gs.away_active_lineup).find(gse.shooter)
		var ocpi: OnCourtPlayerInstance = $Content/VBoxContainer/HBoxContainer/Center/Court/SubViewportContainer/SubViewport.get_child(shooter_ix)
		ocpi.MakeShot(gse.points) if gse.make else ocpi.MissShot()


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
				n.Refresh(gs.player_stats[n.player.id], gs.player_stamina[n.player.id])


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


func _on_timer_timeout():  # tick
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
	
	RenderGSE(gse)
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
