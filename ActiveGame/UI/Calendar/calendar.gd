extends ScrollContainer


var CalendarCell = preload("res://ActiveGame/UI/Calendar/calendar_cell.tscn")
var CalendarEventWidget = preload("res://ActiveGame/UI/Calendar/calendar_event_widget.tscn")


const NUM_DAYS = 7
const WEEK_HEIGHT = 192

var events = {}
var events_OLD = {
	Timestamp.FromStr("2025-2-1-2"): CalendarEvent.new(CalendarEvent.EVENT_TYPE.PRACTICE, "Practice"),
	Timestamp.FromStr("2025-2-1-3"): CalendarEvent.new(CalendarEvent.EVENT_TYPE.PRESS, ""),
	Timestamp.FromStr("2025-2-1-5"): CalendarEventGame.new(CalendarEvent.EVENT_TYPE.GAME, "Non-Conference", 1),
	Timestamp.FromStr("2025-2-2-2"): CalendarEvent.new(CalendarEvent.EVENT_TYPE.PRACTICE, "Practice"),
	Timestamp.FromStr("2025-2-2-3"): CalendarEvent.new(CalendarEvent.EVENT_TYPE.PRESS, ""),
	Timestamp.FromStr("2025-2-2-5"): CalendarEventGame.new(CalendarEvent.EVENT_TYPE.GAME, "Conference", 2),
	Timestamp.FromStr("2025-2-3-2"): CalendarEvent.new(CalendarEvent.EVENT_TYPE.PRACTICE, "Practice"),
	Timestamp.FromStr("2025-2-3-3"): CalendarEvent.new(CalendarEvent.EVENT_TYPE.PRESS, ""),
	Timestamp.FromStr("2025-2-3-5"): CalendarEventGame.new(CalendarEvent.EVENT_TYPE.GAME, "Conference", 3),
}


func _ready():
	pass


func Render(today: Timestamp):
	for cell in $Background/Grid.get_children():
		cell.free()
	
	var num_weeks = Timestamp.PHASE_LENGTHS[today.phase]
	custom_minimum_size.y = clampi(num_weeks * WEEK_HEIGHT, WEEK_HEIGHT, WEEK_HEIGHT * 3)
	
	$Background/Grid.columns = NUM_DAYS
	$Background.custom_minimum_size.y = num_weeks * WEEK_HEIGHT
	
	for w in num_weeks:
		for d in NUM_DAYS:
			var cell = CalendarCell.instantiate()
			$Background/Grid.add_child(cell)
	
	var today_cell = $Background/Grid.get_child(
		today.week * NUM_DAYS + today.day
	)
	today_cell.get_node("IsToday").show()
	
	RenderEvents()


func RenderEvents():
	for timestamp in events:
		var event = events[timestamp]
		
		var widget = CalendarEventWidget.instantiate()
		var cell = GetCell(timestamp)  # todo: handle events not from this phase
		cell.add_child(widget)
		
		widget.Activate(event)


func GetCell(date: Timestamp):
	return $Background/Grid.get_child(
		date.week * NUM_DAYS + date.day
	)


func GetEventAtTime(date: Timestamp):
	for e in events.keys():
		if date.Equals(e):
			return events[e]
	return null
