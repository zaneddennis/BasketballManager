extends Object
class_name Coach


var id: int
var character_id: int

# coaching
var offense: int
var defense: int

# training
var mental: int
var physical: int
var technical: int

# scouting
var evaluation: int
var scouting: int

var school_id: String = ""


static func FromDatabase(coach_id: int) -> Coach:
	var c = Coach.new()
	var dict = Database.GetCoach(coach_id)
	
	c.id = dict["ID"]
	c.character_id = dict["CharacterID"]
	
	c.offense = dict["Offense"]
	c.defense = dict["Defense"]
	
	c.mental = dict["Mental"]
	c.physical = dict["Physical"]
	c.technical = dict["Technical"]
	
	c.evaluation = dict["Evaluation"]
	c.scouting = dict["Scouting"]
	
	c.school_id = dict["SchoolID"]
	
	return c
