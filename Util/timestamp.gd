extends Object
class_name Timestamp


enum PHASE {
	OFFSEASON, PRESEASON, REGULAR_SEASON, CONFERENCE_TOURNAMENT, NATIONAL_TOURNAMENT
}
enum DAY {
	MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}


const PHASE_LENGTHS = {  # weeks
	PHASE.OFFSEASON: 2,
	PHASE.PRESEASON: 2,
	PHASE.REGULAR_SEASON: 8,
	PHASE.CONFERENCE_TOURNAMENT: 1,
	PHASE.NATIONAL_TOURNAMENT: 4
}


var year: int
var phase: PHASE
var week: int
var day: DAY


func _init(y: int, p: PHASE, w: int, d: DAY):
	year = y
	phase = p
	week = w
	day = d


func Advance() -> Array:
	var new_things = []
	
	day += 1
	if day >= 7:
		day = 0
		new_things.append("week")
		
		week += 1
		if week >= PHASE_LENGTHS[phase]:
			week = 0
			new_things.append("phase")
			
			phase += 1
			if phase >= len(PHASE.keys()):
				phase = 0
				year += 1
				new_things.append("season")
	return new_things


func Equals(other: Timestamp):
	if year == other.year and phase == other.phase and week == other.week and day == other.day:
			return true
	return false


# format: YYYY-P_ix-W-D_ix
static func FromStr(s: String) -> Timestamp:
	var vals = s.split("-")
	return Timestamp.new(
		int(vals[0]),
		int(vals[1]),
		int(vals[2]),
		int(vals[3])
	)


func ToISOStr():
	return "%d-%d-%d-%d" % [year, phase, week, day]

func ToPrettyStr():
	return "%d | %s | Week %d | %s" % [
		year, PHASE.keys()[phase].capitalize(), week, DAY.keys()[day].capitalize()
	]


func _to_string():
	return "<Timestamp:%d-%s-%d-%s>" % [
		year, PHASE.keys()[phase], week, DAY.keys()[day]
	]
