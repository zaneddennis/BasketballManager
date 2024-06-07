extends Object
class_name Conference


var id: String
var name: String
var short_name: String


static func FromDatabase(conference_id: String) -> Conference:
	var dict = Database.GetConference(conference_id)
	var c = Conference.new()
	
	c.id = dict["ID"]
	c.name = dict["Name"]
	c.short_name = dict["ShortName"]
	
	return c


func _to_string():
	return "<Conference:%s>" % id
