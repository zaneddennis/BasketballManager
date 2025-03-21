extends EventPage
class_name SelectionShowEventPage


var current_ix = -1
var tournament: Tournament


func Activate(_id):
	print("Activating Selection Show")
	
	PythonManager.CallScript("compute_team_ratings.py", [Database.active_game.slot, 2025])
	
	var year = Database.active_game.current_time.year
	var t = Tournament.New(
		"NAT%d" % year, "", year,
		"""
		SELECT TeamID AS ID, Rating,
			(TeamID IN (SELECT Champion FROM Tournaments)) AS IsConfChamp
		
		FROM
		
		(SELECT Teams.ID AS TeamID, SchoolID, Rating
		FROM Teams
			LEFT JOIN team_ratings_%d ON Teams.SchoolID = team_ratings_%d.ID
		WHERE Year = %d)
		
		ORDER BY IsConfChamp DESC, Rating DESC
		LIMIT 16
		""" % [year, year, year],
		Timestamp.new(year, Timestamp.PHASE.NATIONAL_TOURNAMENT, 0, 0),
		[[], [3, 4], [5, 6], [10, 11], [13]],
		"Rating"
	)
	t.Activate()
	tournament = t
	
	show()


func _on_next_team_pressed() -> void:
	if current_ix >= 15:
		event_completed.emit(self)
	
	else:
		current_ix += 1
		var team = tournament.teams[current_ix]
		$Content/Panel/VBoxContainer.get_child(current_ix).text = "%d. %s %s" % [current_ix+1, team.school.short_name, team.school.mascot]
		
		if current_ix == 15:
			$Content/NextTeam.text = "Complete Selection Show"
