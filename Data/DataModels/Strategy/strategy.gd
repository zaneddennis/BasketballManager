extends Object
class_name Strategy


var lineup: Array[Player]
var roles: Array[PlayerRole]


static func New(l: Array[Player], r: Array[PlayerRole]) -> Strategy:
	var s = Strategy.new()
	s.lineup = l
	s.roles = r
	
	return s

static func FromDict(d: Dictionary) -> Strategy:
	var s = Strategy.new()
	
	s.lineup = [] as Array[Player]
	for p_id in d["Lineup"]:
		s.lineup.append(Player.FromDatabase(p_id))
	for pr_id in d["Roles"]:
		s.roles.append(Database.player_roles[pr_id])
	
	return s

func ToDict() -> Dictionary:
	var d = {}
	d["Lineup"] = lineup.map(func(p: Player): return p.id)
	d["Roles"] = roles.map(func(r: PlayerRole): return r.get_unique_id())
	return d
