extends RefCounted
class_name GameSimulationEvent


var team_ids: Array[String]


var team: GameSimulator.TEAM

var time_elapsed = 15
var home_score_add = 0
var away_score_add = 0
var possession: GameSimulator.TEAM

var description: String = "DEFAULT GSE DESCRIPTION"


func _init(gs: GameSimulator):
	team_ids = [
		gs.game.home.school.id,
		gs.game.away.school.id
	]
	possession = gs.possession


func NextGSEType():
	return GameSimulationEvent


func Turnover():
	if possession == GameSimulator.TEAM.HOME:
		possession = GameSimulator.TEAM.AWAY
	else:
		possession = GameSimulator.TEAM.HOME


func GetTeamID():
	return team_ids[team]
