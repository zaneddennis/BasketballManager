extends Object
class_name Player


var id: int
var character_id: int

enum ELIGIBILITY {FR, SO, JR, SR, SU}
var eligibility: ELIGIBILITY

# physical
var height: int
var weight: int
var agility: int
var strength: int
var vertical_reach: int

# technical
var ball_handling: int
var finishing: int
var shooting: int
var rebounding: int
var perimeter_defense: int
var interior_defense: int

# mental
var vision: int
var off_the_ball: int
var positioning: int

# todo: tendencies

var school_id: String = ""


static func FromDatabase(player_id: int) -> Player:
	var p = Player.new()
	var dict = Database.GetPlayer(player_id)
	
	p.id = dict["ID"]
	p.character_id = dict["CharacterID"]
	
	p.eligibility = ELIGIBILITY.keys().find(dict["Eligibility"])
	
	p.height = dict["Height"]
	p.weight = dict["Weight"]
	p.agility = dict["Agility"]
	p.strength = dict["Strength"]
	p.vertical_reach = dict["Strength"]
	
	p.ball_handling = dict["BallHandling"]
	p.finishing = dict["Finishing"]
	p.shooting = dict["Shooting"]
	p.rebounding = dict["Rebounding"]
	p.perimeter_defense = dict["PerimeterDefense"]
	p.interior_defense = dict["InteriorDefense"]
	
	p.vision = dict["Vision"]
	p.off_the_ball = dict["OffTheBall"]
	p.positioning = dict["Positioning"]
	
	p.school_id = dict["SchoolID"]
	
	return p


func GetCharacter():
	return Character.FromDatabase(character_id)


func _to_string():
	return "<Player:%d>" % [id]
