extends Object
class_name Character


var id: int
var first: String
var last: String
var birth: int

var hometown: Location
var alma_mater: School

var coach_id: int

# todo: personality


static func New(f: String, l: String) -> Character:
	var c = Character.new()
	
	c.first = f
	c.last = l
	
	return c


static func FromDatabase(character_id: int) -> Character:
	var dict = Database.GetItem("Characters", character_id)
	var c = Character.new()
	
	c.id = dict["ID"]
	c.first = dict["First"]
	c.last = dict["Last"]
	c.birth = dict["Birth"]
	
	if dict["Hometown"]:
		c.hometown = Location.FromDatabase(dict["Hometown"])
	
	if dict["AlmaMater"]:
		c.alma_mater = School.FromDatabase(dict["AlmaMater"])
	
	if dict["CoachID"]:
		c.coach_id = dict["CoachID"]
	
	return c

func ToDatabase():
	var dict = {}
	
	dict["ID"] = id
	dict["First"] = first
	dict["Last"] = last
	dict["Birth"] = birth
	dict["Hometown"] = hometown.id
	dict["AlmaMater"] = alma_mater.id
	dict["CoachID"] = coach_id
	
	Database.database.insert_row(
		"Characters",
		dict
	)


func Age():
	return Database.active_game.current_time.year - birth

func FullName():
	return "%s %s" % [first, last]


func _to_string():
	return "<Character:%s_%s>" % [first, last]
