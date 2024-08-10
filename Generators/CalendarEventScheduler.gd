extends RefCounted
class_name CalendarEventScheduler


static func Schedule(date: Timestamp, school_id: String):
	# check for games first
	var game = Database.Get("""
		SELECT *
		FROM Games
		WHERE Timestamp = '%s' AND (Home = '%s' OR Away = '%s')
	""" % [date.ToISOStr(), school_id, school_id])
	if game:
		game = game[0]
		var opp = ""
		if game["Home"] == school_id:
			opp = "vs " + game["Away"]
		else:
			opp = "@ " + game["Home"]
		
		return CalendarEventGame.new(
			CalendarEvent.EVENT_TYPE.GAME,
			opp,
			date,
			game["ID"]
		)
	else:
		return ScheduleDefault(date)


# the default CalendarEvent for a day, barring a Game
static func ScheduleDefault(date: Timestamp):
	if date.phase == Timestamp.PHASE.OFFSEASON:
		return ScheduleOffseason(date)
	elif date.phase in [Timestamp.PHASE.PRESEASON, Timestamp.PHASE.REGULAR_SEASON]:
		return ScheduleSeason(date)


static func ScheduleOffseason(date: Timestamp):
	if date.day in [0, 2, 4]:
		return CalendarEvent.new(
			CalendarEvent.EVENT_TYPE.PRACTICE,
			"Offseason",
			date
		)
	elif date.day in [1, 3]:
		return CalendarEvent.new(
			CalendarEvent.EVENT_TYPE.MEETING,
			"",
			date
		)


static func ScheduleSeason(date: Timestamp):
	#if date.day in [0, 1, 2, 3, 4]:
	if date.day in [1, 3]:
		return CalendarEvent.new(
			CalendarEvent.EVENT_TYPE.PRACTICE,
			"Offseason",
			date
		)
	elif date.day == 6:
		return CalendarEvent.new(
			CalendarEvent.EVENT_TYPE.MEETING,
			"",
			date
		)
