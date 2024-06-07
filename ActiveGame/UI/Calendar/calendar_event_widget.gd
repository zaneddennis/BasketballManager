extends Panel


const EVENT_COLORS = [
	Color("757575"),
	Color("7d9f35"),
	Color("343477"),
	Color("aa8e39"),
	Color("aa3c39")
]


func Activate(e: CalendarEvent):
	# set text
	$VBoxContainer/Title.text = CalendarEvent.EVENT_TYPE.keys()[e.event_type]
	$VBoxContainer/Subtitle.text = "- " + e.event_subtype
	
	# set color
	var stylebox = get_theme_stylebox("panel").duplicate()
	stylebox.set("bg_color", EVENT_COLORS[e.event_type])
	add_theme_stylebox_override("panel", stylebox)
