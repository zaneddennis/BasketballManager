extends ScrollContainer


var CalendarCell = preload("res://ActiveGame/UI/Calendar/calendar_cell.tscn")
var CalendarEventWidget = preload("res://ActiveGame/UI/Calendar/calendar_event_widget.tscn")


const NUM_DAYS = 7
const WEEK_HEIGHT = 192


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
			
			var event_this_day = CalendarEventScheduler.Schedule(Timestamp.new(today.year, today.phase, w, d), Database.active_game.player_school_id)
			if event_this_day:
				var widget = CalendarEventWidget.instantiate()
				cell.add_child(widget)
				widget.Activate(event_this_day)
	
	var today_cell = $Background/Grid.get_child(
		today.week * NUM_DAYS + today.day
	)
	today_cell.get_node("IsToday").show()


func GetCell(date: Timestamp):
	return $Background/Grid.get_child(
		date.week * NUM_DAYS + date.day
	)
