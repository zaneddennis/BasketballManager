extends Object
class_name Game


var id: int
var timestamp: Timestamp
var home: Team
var away: Team
var home_score: int
var away_score: int


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
	var g = Game.new()
	var dict = Database.GetItem("Games", game_id)
	
	g.id = dict["ID"]
	g.timestamp = Timestamp.FromStr(dict["Timestamp"])
	g.home = Team.FromDatabase(dict["Home"] + str(g.timestamp.year))
	g.away = Team.FromDatabase(dict["Away"] + str(g.timestamp.year))
	
	return g
