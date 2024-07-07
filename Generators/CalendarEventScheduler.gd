extends RefCounted
class_name CalendarEventScheduler


static func Schedule(date: Timestamp):
	if date.phase == Timestamp.PHASE.OFFSEASON:
		return ScheduleOffseason(date)
	elif date.phase in [Timestamp.PHASE.PRESEASON, Timestamp.PHASE.REGULAR_SEASON]:
		return ScheduleSeason(date)


static func ScheduleOffseason(date: Timestamp):
	if date.day in [0, 2, 4]:
		return CalendarEvent.new(
			CalendarEvent.EVENT_TYPE.PRACTICE,
			"Offseason"
		)
	elif date.day in [1, 3]:
		return CalendarEvent.new(
			CalendarEvent.EVENT_TYPE.MEETING,
			""
		)


# todo: account for Games
static func ScheduleSeason(date: Timestamp):
	if date.day in [0, 1, 2, 3, 4]:
		return CalendarEvent.new(
			CalendarEvent.EVENT_TYPE.PRACTICE,
			"Offseason"
		)
	elif date.day == 5:
		return CalendarEvent.new(
			CalendarEvent.EVENT_TYPE.MEETING,
			""
		)
