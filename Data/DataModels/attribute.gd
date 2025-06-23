extends RefCounted
class_name Attribute


const ALL_ATTRS = [
	"agility", "strength", "vertical_reach", "endurance",
	"ball_handling", "passing", "finishing", "shooting", "rebounding", "perimeter_defense", "interior_defense",
	"vision", "off_the_ball", "positioning"
]


const MAX_VIS = 20


enum CATEGORY{PHYSICAL, TECHNICAL, MENTAL, PERSONALITY}
enum AFFECTED_BY{STAMINA, RHYTHM, MORALE, CONFIDENCE, CHEMISTRY}  # ???

var name: String
var category: CATEGORY
var base: float  # [0, 1]
var potential: float  # [0, 1]
var affected_by: Array[AFFECTED_BY]  # TODO: set this from name



func _init(n: String, x: float, pot: float) -> void:
	name = n
	base = x
	potential = pot


func Get() -> int:
	return max(1, floori(MAX_VIS * base))


func _to_string() -> String:
	return "<Attribute:%.2f>" % base
