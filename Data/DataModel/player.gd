extends Object
class_name Player


var id: int
#var character_id: int
var character: Character

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


static func New(char: Character, h: int, w: int,
				agl:int, str: int, vr: int,
				hdl: int, fin: int, sho: int, reb: int, prd: int, ind: int,
				vis: int, otb: int, pos: int) -> Player:
	var p = Player.new()
	
	p.character = char
	
	p.height = h
	p.weight = w
	
	p.agility = agl
	p.strength = str
	p.vertical_reach = vr
	p.ball_handling = hdl
	p.finishing = fin
	p.shooting = sho
	p.rebounding = reb
	p.perimeter_defense = prd
	p.interior_defense = ind
	p.vision = vis
	p.off_the_ball = otb
	p.positioning = pos
	
	return p


static func FromDatabase(player_id: int) -> Player:
	var p = Player.new()
	var dict = Database.GetItem("Players", player_id)
	
	p.id = dict["ID"]
	#p.character_id = dict["CharacterID"]
	p.character = Character.FromDatabase(dict["CharacterID"])
	
	p.eligibility = ELIGIBILITY.keys().find(dict["Eligibility"])
	
	p.height = dict["Height"]
	p.weight = dict["Weight"]
	p.agility = dict["Agility"]
	p.strength = dict["Strength"]
	p.vertical_reach = dict["VerticalReach"]
	
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


func _to_string():
	return "<Player:%d:%s:%s>" % [id, character.first, character.last]
