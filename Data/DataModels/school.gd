extends Object
class_name School


# static
var id: String
var full_name: String
var short_name: String
var mascot: String
var location: Location

var color1: Color
var color2: Color

# dynamic
var conference: Conference
var prestige: Prestige


static func New(abb: String, sn: String, m: String,
				c1: Color = Color.BLACK, c2: Color = Color.WHITE) -> School:
	var s = School.new()
	
	s.id = abb
	s.short_name = sn
	s.mascot = m
	
	s.color1 = c1
	s.color2 = c2
	
	return s


static func FromDatabase(school_id: String) -> School:
	var dict = Database.GetItem("Schools", school_id)
	var s = School.new()
	
	s.id = dict["ID"]
	s.full_name = dict["FullName"]
	s.short_name = dict["ShortName"]
	s.mascot = dict["Mascot"]
	s.location = Location.FromDatabase(dict["Location"])
	s.color1 = Color(dict["Color1"])
	s.color2 = Color(dict["Color2"])
	
	s.conference = Conference.FromDatabase(dict["Conference"])
	s.prestige = Prestige.new(dict["PrestigeHistoric"], dict["PrestigeCurrent"])
	
	return s


func _to_string():
	return "<School:%s>" % id
