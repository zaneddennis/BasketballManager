extends Object
class_name Game


var id: int
var timestamp: Timestamp
var home: Team
var away: Team
var home_score: int
var away_score: int


static func FromDatabase(game_id: int) -> Game:
	var g = Game.new()
	var dict = Database.GetGame(game_id)
	
	g.id = dict["ID"]
	g.timestamp = Timestamp.FromStr(dict["Timestamp"])
	g.home = Team.FromDatabase(dict["Home"])
	g.away = Team.FromDatabase(dict["Away"])
	
	return g
