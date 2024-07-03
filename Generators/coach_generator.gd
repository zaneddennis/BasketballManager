extends RefCounted
class_name CoachGenerator


func GenerateCoach(id: int, character_id: int) -> Dictionary:
	var overall = clamp(randfn(8.0, 4.0), 1, 20)
	var strategy = clamp(randfn(overall, 3.0), 1, 20)
	var development = clamp(randfn(overall, 3.0), 1, 20)
	var evaluation = clamp(randfn(overall, 3.0), 1, 20)
	
	return {
		"ID": id,
		"CharacterID": character_id,
		"Offense": clampi(randfn(strategy, 2.0), 1, 20),
		"Defense": clampi(randfn(strategy, 2.0), 1, 20),
		"Mental": clampi(randfn(development, 2.0), 1, 20),
		"Physical": clampi(randfn(development, 2.0), 1, 20),
		"Technical": clampi(randfn(development, 2.0), 1, 20),
		"Evaluation": clampi(randfn(evaluation, 2.0), 1, 20),
		"Scouting": clampi(randfn(evaluation, 2.0), 1, 20),
	}
