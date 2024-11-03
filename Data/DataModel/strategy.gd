extends Object
class_name Strategy


var lineup: Array[Player]


static func New(l: Array[Player]) -> Strategy:
	var s = Strategy.new()
	s.lineup = l
	
	return s
