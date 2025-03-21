extends Panel


# TODO: redo
#const EVENT_COLORS = [
	#Color("757575"),  # default
	#Color("7d9f35"),  # practice
	#Color("343477"),  # meeting
	#Color("aa8e39"),  # press
	#Color("aa3c39"),  # game
	#
#]
const EVENT_COLORS = {
	CalendarEvent.EVENT_TYPE.DEFAULT: ColorsUtil.PALLETTE.grey[2],
	CalendarEvent.EVENT_TYPE.PRACTICE: ColorsUtil.PALLETTE.green[2],
	CalendarEvent.EVENT_TYPE.MEETING: ColorsUtil.PALLETTE.blue[2],
	CalendarEvent.EVENT_TYPE.PRESS: ColorsUtil.PALLETTE.gold[2],
	CalendarEvent.EVENT_TYPE.GAME: ColorsUtil.PALLETTE.red[2],
	CalendarEvent.EVENT_TYPE.SELECTION_SHOW: ColorsUtil.PALLETTE.purple[2]
}


func Activate(e: CalendarEvent):
	# set text
	$VBoxContainer/Title.text = CalendarEvent.EVENT_TYPE.keys()[e.event_type].replace("_", " ")
	$VBoxContainer/Subtitle.text = e.event_subtype
	
	# set color
	var stylebox = get_theme_stylebox("panel").duplicate()
	stylebox.set("bg_color", EVENT_COLORS[e.event_type])
	add_theme_stylebox_override("panel", stylebox)
