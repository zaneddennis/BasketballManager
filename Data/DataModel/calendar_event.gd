extends RefCounted
class_name CalendarEvent


enum EVENT_TYPE {DEFAULT, PRACTICE, MEETING, PRESS, GAME}

var event_type: EVENT_TYPE = EVENT_TYPE.DEFAULT
var event_subtype: String  # todo: make this not just a String


func _init(et: EVENT_TYPE, est: String):
	event_type = et
	event_subtype = est
