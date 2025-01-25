extends RefCounted
class_name CourtLocation


enum HALF{WEST, EAST}
enum AREA{VALVE, PERIMETER, CORNER, FT_LINE, ELBOW, FLAT, BLOCK,
			TIPOFF_G, TIPOFF_F, TIPOFF_C}
enum SIDE{LEFT, RIGHT, CENTER}
const CENTERLESS_AREAS = [AREA.CORNER, AREA.ELBOW, AREA.FLAT, AREA.BLOCK]

const BASKET_LOC = [Vector2(50, 200), Vector2(550, 200)]

const VECTORS = {
	AREA.VALVE: Vector2(225, 100),
	AREA.PERIMETER: Vector2(125, 100),
	AREA.CORNER: Vector2(0, 135),
	AREA.FT_LINE: Vector2(100, 35),
	AREA.ELBOW: Vector2(100, 60),
	AREA.FLAT: Vector2(25, 60),
	AREA.BLOCK: Vector2(25, 40),
	AREA.TIPOFF_G: Vector2(150, -50),
	AREA.TIPOFF_F: Vector2(225, -100),
	AREA.TIPOFF_C: Vector2(225, 0)
}

const SHOT_TYPES = {  # AREA: ShotGSE.SHOT_TYPE
	AREA.VALVE: ShotGSE.SHOT_TYPE.LONG_THREE,
	AREA.PERIMETER: ShotGSE.SHOT_TYPE.THREE,
	AREA.CORNER: ShotGSE.SHOT_TYPE.THREE,
	AREA.FT_LINE: ShotGSE.SHOT_TYPE.MIDRANGE,
	AREA.FLAT: ShotGSE.SHOT_TYPE.SHORT,
	AREA.BLOCK: ShotGSE.SHOT_TYPE.LAYUP,
}


var half: HALF
var area: AREA
var side: SIDE
#var is_def: bool
var def_mod = null  # [-1, 1]


func _init(_half: HALF, _area: AREA, _side: SIDE, _def_mod = null) -> void:
	half = _half
	area = _area
	side = _side
	
	if _def_mod != null:
		def_mod = _def_mod

static func FromStrs(_half: String, _area: String, _side: String, _def_mod = null) -> CourtLocation:
	var h = HALF.values()[HALF.keys().find(_half)]
	var a = AREA.values()[AREA.keys().find(_area)]
	var s = SIDE.values()[SIDE.keys().find(_side)]
	var dm = _def_mod
	
	return CourtLocation.new(h, a, s, dm)


func GetPosition() -> Vector2:
	var basket_loc = BASKET_LOC[half]
	var vector = VECTORS[area]
	
	if [area, side] == [AREA.PERIMETER, SIDE.CENTER]:
		vector.x += 50
	
	var multiplier = Vector2(1, 1)
	if half == HALF.EAST:
		multiplier.x = -1
	if int(side) != int(half):
		if side == SIDE.CENTER:
			multiplier.y = 0
		else:
			multiplier.y = -1
	
	var position = basket_loc + vector * multiplier
	
	if def_mod != null:
		var dist = 60 if area == AREA.VALVE else 30
		dist += def_mod * 20
		position = position.move_toward(basket_loc, max(20, dist))
	
	return position


func IsPost():
	if area in [AREA.BLOCK, AREA.FT_LINE]:
		return true
	else:
		return false


# NOTE: does not account for def_mod
func Equals(other: CourtLocation) -> bool:
	if half == other.half and area == other.area and side == other.side:
		return true
	return false


func _to_string() -> String:
	return "<CourtLocation:%s:%s:%s:%s>" % [
		HALF.keys()[half],
		AREA.keys()[area],
		SIDE.keys()[side],
		"OFF" if def_mod == null else "DEF"
	]
