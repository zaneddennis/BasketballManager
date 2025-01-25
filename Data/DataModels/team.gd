extends Object
class_name Team


var id: String
var school: School
var year: int

var wins: int = 0
var losses: int = 0

var head_coach: Coach
var players: Array[Player]
var strategy: Strategy


# assumes p Array is given in lineup order
static func New(s: School, p: Array[Player], st: Strategy = null) -> Team:
	var t = Team.new()
	
	t.school = s
	t.players = p
	if st:
		t.strategy = st
	else:
		t.strategy = Strategy.New(
			t.players, []
		)
	
	return t


static func FromDatabase(team_id: String) -> Team:
	var dict = Database.GetItem("Teams", team_id)
	return _from_dict(dict)


func UpdateDatabase():
	Database.UpdateRow(
		"Teams", id,
		ToDict(true)
	)


static func _from_dict(dict: Dictionary) -> Team:
	var t = Team.new()
	
	t.id = dict["ID"]
	var school_id = dict["SchoolID"]
	t.school = School.FromDatabase(school_id)
	t.year = dict["Year"]
	
	t.wins = dict["Wins"]
	t.losses = dict["Losses"]
	
	var coach_id = dict["HeadCoach"]
	t.head_coach = Coach.FromDatabase(coach_id)
	
	var player_ids = dict["Players"].split(",")
	var players: Array[Player] = []
	for p_id in player_ids:
		players.append(Player.FromDatabase(int(p_id)))
	t.players = players
	
	t.strategy = Strategy.FromDict(JSON.parse_string(dict["Strategy"]))
	
	return t


func ToDict(strify: bool = false) -> Dictionary:
	var d = {}
	
	d["ID"] = id
	d["SchoolID"] = school.id
	d["Year"] = year
	
	d["Wins"] = wins
	d["Losses"] = losses
	
	d["HeadCoach"] = head_coach.id
	d["Players"] = players.map(func(p: Player): return p.id)
	if strify:
		d["Players"] = str(d["Players"])
	d["Strategy"] = strategy.ToDict()
	if strify:
		d["Strategy"] = str(d["Strategy"])
	
	print(d)
	return d


func _to_string():
	return "<Team:%s:%s:%d>" % [id, school.id, year]
