extends Object
class_name School


var id: String
var full_name: String
var short_name: String
var mascot: String
var location: Location

var conference: Conference

var prestige: Prestige


static func FromDatabase(school_id: String) -> School:
	var dict = Database.GetSchool(school_id)
	var s = School.new()
	
	s.id = dict["ID"]
	s.full_name = dict["FullName"]
	s.short_name = dict["ShortName"]
	s.mascot = dict["Mascot"]
	s.conference = Conference.FromDatabase(dict["Conference"])
	s.location = Location.FromDatabase(dict["Location"])
	
	s.prestige = Prestige.new(dict["PrestigeHistoric"], dict["PrestigeCurrent"])
	
	return s


func _to_string():
	return "<School:%s>" % id
