extends RefCounted
class_name GameSimulationEvent


var team_ids: Array[String]


var team: GameSimulator.TEAM
var offense_players: Array[Player]
var defense_players: Array[Player]

var time_elapsed = 15
var home_score_add = 0
var away_score_add = 0
var possession: GameSimulator.TEAM

var player_deltas = {}  # {player_id: Statline}

var description: String = "DEFAULT GSE DESCRIPTION"
var next = GameSimulationEvent
var next_config = {}


func _init(gs: GameSimulator, config: Dictionary = {}):
	team_ids = [
		gs.game.home.school.id,
		gs.game.away.school.id
	]
	possession = gs.possession
	
	if possession == GameSimulator.TEAM.HOME:
		offense_players = gs.home_active_lineup
		defense_players = gs.away_active_lineup
	else:
		offense_players = gs.away_active_lineup
		defense_players = gs.home_active_lineup


func Simulate(gs: GameSimulator):
	pass


func NextGSEType():
#	return GameSimulationEvent
	return next


func Turnover():
	if possession == GameSimulator.TEAM.HOME:
		possession = GameSimulator.TEAM.AWAY
	else:
		possession = GameSimulator.TEAM.HOME


func GetTeamID():
	return team_ids[team]
