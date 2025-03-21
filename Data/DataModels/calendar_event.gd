extends RefCounted
class_name CalendarEvent


enum EVENT_TYPE {
	DEFAULT,
	# basic events
	PRACTICE, MEETING, PRESS, GAME,
	# special events
	SELECTION_SHOW
}

var event_type: EVENT_TYPE = EVENT_TYPE.DEFAULT
var event_subtype: String  # todo: make this not just a String


func _init(et: EVENT_TYPE, est: String, ts: Timestamp):
	event_type = et
	event_subtype = est

func _to_string():
	return "<CalendarEvent:%s>" % EVENT_TYPE.keys()[event_type]
