extends CalendarEvent
class_name CalendarEventGame


var game_id: int

func _init(et: EVENT_TYPE, est: String, ts: Timestamp, gid: int):
	super(et, est, ts)
	
	game_id = gid