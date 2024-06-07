extends CalendarEvent
class_name CalendarEventGame


var game_id: int

func _init(et: EVENT_TYPE, est: String, gid: int):
	super(et, est)
	
	game_id = gid
