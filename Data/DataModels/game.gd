extends Object
class_name Game


var id: int
var timestamp: Timestamp
var home: Team
var away: Team
var home_score: int
var away_score: int

var conference: Conference
#var tournament: Tournament
var tournament_id: String


static func New(h: Team, a: Team) -> Game:
	var g = Game.new()
	
	g.id = -1
	g.timestamp = Timestamp.FromStr("0-0-0-0")
	
	g.home = h
	g.away = a
	
	g.home_score = 0
	g.away_score = 0
	
	return g


static func FromDatabase(game_id: int) -> Game:
	var dict = Database.GetItem("Games", game_id)
	return _from_dict(dict)


static func _from_dict(dict: Dictionary) -> Game:
	var g = Game.new()
	
	g.id = dict["ID"]
	g.timestamp = Timestamp.FromStr(dict["Timestamp"])
	g.home = Team.FromDatabase(dict["Home"] + str(g.timestamp.year))
	g.away = Team.FromDatabase(dict["Away"] + str(g.timestamp.year))
	if "ConferenceID" in dict and dict["ConferenceID"]:
		g.conference = Conference.FromDatabase(dict["ConferenceID"])
	if "TournamentID" in dict and dict["TournamentID"]:
		g.tournament_id = dict["TournamentID"]
	
	if "HomeScore" in dict and dict["HomeScore"]:
		g.home_score = dict["HomeScore"]
		g.away_score = dict["AwayScore"]
	
	return g


func _to_string() -> String:
	return "<Game:%s@%s>" % [home.school.id, away.school.id]
