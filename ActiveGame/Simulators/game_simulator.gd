extends RefCounted
class_name GameSimulator


enum TEAM{HOME, AWAY}


var game: Game

var time = 60 * 20
var half = 1
var possession: TEAM
var home_score = 0
var away_score = 0

var player_stats: Dictionary  # {player_id: Statline}
var player_stamina: Dictionary  # {player_id: float[0-1]}

var home_active_lineup: Array[Player]
var away_active_lineup: Array[Player]
var player_locs: Dictionary  # {player_id: CourtLocation}
var ball_handler_ix: int = -1  # [0-9] player with possession of the ball, if applicable
var ball_pos: Vector2 = Vector2.ZERO  # relative to basket, if not held by a player
var ball_half: CourtLocation.HALF

var last_gse: GameSimulationEvent
var lost_tipoff: TEAM


func _init(g: Game):
	game = g
	home_active_lineup = game.home.strategy.lineup.slice(0, 5)
	away_active_lineup = game.away.strategy.lineup.slice(0, 5)
	
	var all_players = game.home.players + game.away.players
	for p: Player in all_players:
		player_stats[p.id] = Statline.new()
		player_stamina[p.id] = 1.0
	
	StartHalf(1)


func StartHalf(h: int):
	time = 60 * 20
	half = h


func Simulate() -> GameResult:
	for h in [1, 2]:
		StartHalf(h)
		while time > 0:
			var gse = Tick()
	
	return CompileResult()


func Tick() -> GameSimulationEvent:
	var gse = null
	if not last_gse:
		gse = TipoffGSE.new(self)
	elif last_gse is EndOfHalfGSE:
		possession = lost_tipoff
		#gse = HalfcourtGSEv2.new(self, last_gse.next_config)
		gse = TransitionGSE.new(self, {"is_fast_break": false, "is_after_made": true})
	elif time <= 0:
		gse = EndOfHalfGSE.new(self, last_gse.next_config)
	else:
		gse = last_gse.NextGSEType().new(self, last_gse.next_config)
	
	print(gse.description)
	
	time -= gse.time_elapsed
	if time <= 0:
		time = 0
	
	# team stats/status
	home_score += gse.home_score_add
	away_score += gse.away_score_add
	possession = gse.possession
	
	# player stats
	for player_id: int in gse.player_deltas:
		var delta = gse.player_deltas[player_id]
		player_stats[player_id].Add(delta)
	
	for player_id: int in gse.player_staminas:
		var delta = gse.player_staminas[player_id]
		player_stamina[player_id] -= delta
	
	# player positions
	player_locs = gse.player_locs
	
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


func GetBallHandlingPlayer():  # Player or null
	if ball_handler_ix == -1:
		return null
	else:
		return (home_active_lineup + away_active_lineup)[ball_handler_ix]

func SetBallhandler(player: Player):
	ball_handler_ix = (home_active_lineup + away_active_lineup).find(player)


func GetOpenLocations(
	half: CourtLocation.HALF,
	filter_areas: Array[CourtLocation.AREA] = [],
	planned_movements_from: Array[CourtLocation] = [],
	planned_movements_to: Array[CourtLocation] = []):
	var possible_locs = []
	
	for area in CourtLocation.AREA.values():
		for side in CourtLocation.SIDE.values():
			var loc = CourtLocation.new(half, area, side)
			var is_valid = true
			
			# check if valid area
			if "TIPOFF" in CourtLocation.AREA.keys()[area]:
				is_valid = false
			
			# check if valid area/side combination
			if (side == CourtLocation.SIDE.CENTER) and (area in CourtLocation.CENTERLESS_AREAS):
				is_valid = false
			
			# check if area passes the filter, if filter exists
			if filter_areas and area not in filter_areas:
					is_valid = false
			
			if is_valid:
				possible_locs.append(loc)

	# remove locs where a player is already there
	var already_filled = player_locs.values() + planned_movements_to
	for loc in already_filled:
		#if not loc in planned_movements_from:
		if not Util.List.IsIn(planned_movements_from, loc):
			var ix = Util.List.Find(possible_locs, loc)
			if ix != -1:
				possible_locs.remove_at(ix)
	
	return possible_locs


static func Roll(player: Player, attrs: Dictionary, randomness: float) -> float:  # ~N(a, r) where a [0.0, 1.0]
	var wc = WeightedChoice.new(attrs.keys().map(func(k): return float(player.get(k))), attrs.values())
	var center = (wc.Average() - 10.0) / 10.0
	return randfn(center, randomness)
