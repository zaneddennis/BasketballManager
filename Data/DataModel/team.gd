extends Object
class_name Team


var id: int
var school: School
var year: int

var head_coach: Coach
var players: Array[Player]


static func FromDatabase(team_id: int) -> Team:
	var dict = Database.GetTeam(team_id)
	var t = Team.new()
	
	t.id = dict["ID"]
	var school_id = dict["SchoolID"]
	t.school = School.FromDatabase(school_id)
	t.year = dict["Year"]
	
	var coach_id = dict["HeadCoach"]
	t.head_coach = Coach.FromDatabase(coach_id)
	
	var player_ids = dict["Players"].split(",")
	var players: Array[Player] = []
	for p_id in player_ids:
		players.append(Player.FromDatabase(int(p_id)))
	t.players = players
	
	return t


func _to_string():
	return "<Team:%d:%s:%d>" % [id, school.id, year]
