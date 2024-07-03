extends RefCounted
class_name CharacterGenerator


var location_picker: WeightedChoice
# todo: factor out last_picker


const GAME_YEAR = 2025  # todo

const MIN_COACH_AGE = 30
const MAX_COACH_AGE = 35
const MIN_PLAYER_AGE = 19
const MAX_PLAYER_AGE = 22


func _init():
	location_picker = WeightedChoice.new(  # todo: data pipeline
		range(1, 9),
		[13.0, 4.0, 1.5, 1.0, 2.0, 0.6, 10.0, 12.0]
	)


func GenerateCoach(id: int, coach_id: int) -> Dictionary:
	var min_year = GAME_YEAR - MAX_COACH_AGE
	var max_year = GAME_YEAR - MIN_COACH_AGE
	
	var school_ids = Database.GetColumnAsList("Schools", "ID", "ID")
	
	var year = randi_range(min_year, max_year)
	
	var firsts = Database.GetFirstNamesForYear(year)
	var first_picker = WeightedChoice.new(
		firsts[0], firsts[1]
	)
	var lasts = Database.GetLastNames()
	var last_picker = WeightedChoice.new(
		lasts[0], lasts[1]
	)
	
	return {
		"ID": id,
		"First": first_picker.Pick(),
		"Last": last_picker.Pick(),
		"Birth": year,
		"Hometown": location_picker.Pick(),
		"AlmaMater": school_ids.pick_random(),
		"CoachID": coach_id
	}


func GeneratePlayer(id: int, player_id: int):
	var min_year = GAME_YEAR - MAX_PLAYER_AGE
	var max_year = GAME_YEAR - MIN_PLAYER_AGE
	var year = randi_range(min_year, max_year)
	
	var firsts = Database.GetFirstNamesForYear(year)
	var first_picker = WeightedChoice.new(
		firsts[0], firsts[1]
	)
	var lasts = Database.GetLastNames()
	var last_picker = WeightedChoice.new(
		lasts[0], lasts[1]
	)
	
	return {
		"ID": id,
		"First": first_picker.Pick(),
		"Last": last_picker.Pick(),
		"Birth": year,
		"Hometown": location_picker.Pick(),
		"PlayerID": player_id
	}
