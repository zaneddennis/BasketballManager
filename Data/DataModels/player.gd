extends Object
class_name Player


var id: int
var character: Character

enum ELIGIBILITY {FR, SO, JR, SR, SU}
var eligibility: ELIGIBILITY
var jersey_number: int

# physical
var height: int  # inches
var weight: int  # pounds

var agility: Attribute
var strength: Attribute
var vertical_reach: Attribute
var endurance: Attribute

# technical
var ball_handling: Attribute
var passing: Attribute
var finishing: Attribute
var shooting: Attribute
var rebounding: Attribute
var perimeter_defense: Attribute
var interior_defense: Attribute

# mental
var vision: Attribute
var off_the_ball: Attribute
var positioning: Attribute

# todo: tendencies

var school: School


static func New(char: Character, i: int, j:int, h: int, w: int,
				agl: float, str: float, vr: float, end: float,
				hdl: float, pas: float, fin: float, sho: float, reb: float, prd: float, ind: float,
				vis: float, otb: float, pos: float,
				sch: School = null,
				pot: Dictionary = {
					Attribute.CATEGORY.PHYSICAL: 1.0,
					Attribute.CATEGORY.TECHNICAL: 1.0,
					Attribute.CATEGORY.MENTAL: 1.0
				}) -> Player:
	var p = Player.new()
	
	p.character = char
	p.id = i
	p.jersey_number = j
	
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
	
	p.school = sch
	
	p.potentials = pot
	
	return p


static func FromDatabase(player_id: int) -> Player:
	var p = Player.new()
	var dict = Database.GetItem("Players", player_id)
	
	p.id = dict["ID"]
	p.character = Character.FromDatabase(dict["CharacterID"])
	
	p.eligibility = ELIGIBILITY.keys().find(dict["Eligibility"])
	p.jersey_number = 0  # TODO
	
	p.height = dict["Height"]
	p.weight = dict["Weight"]
	p.agility = Attribute.new("agility", dict["Agility"], dict["PotentialAgility"])
	p.strength = Attribute.new("strength", dict["Strength"], dict["PotentialStrength"])
	p.vertical_reach = Attribute.new("vertical_reach", dict["VerticalReach"], dict["PotentialVerticalReach"])
	p.endurance = Attribute.new("endurance", dict["Endurance"], dict["PotentialEndurance"])
	
	p.ball_handling = Attribute.new("ball_handling", dict["BallHandling"], dict["PotentialBallHandling"])
	p.passing = Attribute.new("passing", dict["Passing"], dict["PotentialPassing"])
	p.finishing = Attribute.new("finishing", dict["Finishing"], dict["PotentialFinishing"])
	p.shooting = Attribute.new("shooting", dict["Shooting"], dict["PotentialShooting"])
	p.rebounding = Attribute.new("rebounding", dict["Rebounding"], dict["PotentialRebounding"])
	p.perimeter_defense = Attribute.new("perimeter_defense", dict["PerimeterDefense"], dict["PotentialPerimeterDefense"])
	p.interior_defense = Attribute.new("interior_defense", dict["InteriorDefense"], dict["PotentialInteriorDefense"])
	
	p.vision = Attribute.new("vision", dict["Vision"], dict["PotentialVision"])
	p.off_the_ball = Attribute.new("off_the_ball", dict["OffTheBall"], dict["PotentialOffTheBall"])
	p.positioning = Attribute.new("positioning", dict["Positioning"], dict["PotentialPositioning"])
	
	p.school = School.FromDatabase(dict["SchoolID"])
	
	return p


func GetBodyStr():
	return "%d'%s\", %d lb" % [height / 12, height % 12, weight]


func _to_string():
	return "<Player:%d:%s:%s>" % [id, character.first, character.last]
