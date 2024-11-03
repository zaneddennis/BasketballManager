extends RefCounted
class_name GameSimulator


enum TEAM{HOME, AWAY}


var game: Game


var time = 60 * 20
var half = 1
var possession: TEAM
var home_score = 0
var away_score = 0
var home_active_lineup: Array[Player]
var away_active_lineup: Array[Player]

var last_gse: GameSimulationEvent
var lost_tipoff: TEAM


func _init(g: Game):
	game = g
	home_active_lineup = game.home.strategy.lineup.slice(0, 5)
	away_active_lineup = game.away.strategy.lineup.slice(0, 5)
	StartHalf(1)


func StartHalf(h: int):
	time = 60 * 20
	half = h


func Simulate() -> GameResult:
	for h in [1, 2]:
		StartHalf(h)
		while time > 0:
			var gse = Tick()
			print(gse.description)
	
	return CompileResult()


func Tick() -> GameSimulationEvent:
	var gse = null
	if not last_gse:
		gse = TipoffGSE.new(self)
	elif last_gse is EndOfHalfGSE:
		possession = lost_tipoff
		gse = HalfcourtGSE.new(self)
	elif time <= 0:
		gse = EndOfHalfGSE.new(self)
	else:
		gse = last_gse.NextGSEType().new(self)
	
	time -= gse.time_elapsed
	if time <= 0:
		time = 0
	
	home_score += gse.home_score_add
	away_score += gse.away_score_add
	possession = gse.possession
	
	# TODO: clean interface to consume different types of GSE in separate functions
	if gse is TipoffGSE:
		if gse.won_by == TEAM.HOME:
			lost_tipoff = TEAM.AWAY
		else:
			lost_tipoff = TEAM.HOME
	
	last_gse = gse
	return gse


func CompileResult() -> GameResult:
	return GameResult.new(home_score, away_score)
