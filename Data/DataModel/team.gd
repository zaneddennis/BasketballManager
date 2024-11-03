extends Object
class_name Team


#var id: int
var id: String
var school: School
var year: int

var head_coach: Coach
var players: Array[Player]
var strategy: Strategy


# assumes p Array is given in lineup order
static func New(s: School, p: Array[Player]) -> Team:
	var t = Team.new()
	
	t.school = s
	t.players = p
	t.strategy = Strategy.New(
		t.players
	)
	
	return t


static func FromDatabase(team_id: String) -> Team:
	var dict = Database.GetItem("Teams", team_id)
	return _from_dict(dict)


static func _from_dict(dict: Dictionary) -> Team:
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
	return "<Team:%s:%s:%d>" % [id, school.id, year]
