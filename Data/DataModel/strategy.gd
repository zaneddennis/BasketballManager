extends Object
class_name Strategy


var lineup: Array[Player]


static func New(l: Array[Player]) -> Strategy:
	var s = Strategy.new()
	s.lineup = l
	
	return s

static func FromDict(d: Dictionary) -> Strategy:
	var s = Strategy.new()
	
	s.lineup = [] as Array[Player]
	for p_id in d["Lineup"]:
		s.lineup.append(Player.FromDatabase(p_id))
	
	return s
