extends Node
class_name Location


var id: int
var city: String
var state: String  # just the two-letter code for now

static func FromDatabase(location_id: int):
	var dict = Database.GetLocation(location_id)
	var l = Location.new()
	
	l.id = dict["ID"]
	l.city = dict["City"]
	l.state = dict["State"]
	
	return l


func ToPrettyStr():
	return "%s, %s" % [city, state]
