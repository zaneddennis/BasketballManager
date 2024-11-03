extends GameSimulationEvent
class_name ShotGSE


func _init(gs: GameSimulator):
	super(gs)
	
	team = gs.possession
	
	time_elapsed = randi_range(1, min(3, gs.time))
	
	var attempt = 0
	var points = 0
	var made = "missed"
	
	var roll = randf()
	if roll < .8:
		# attempt 2 pointer
		attempt = 2
		if randf() < 0.5:
			points = 2
	else:
		# attempt 3 pointer
		attempt = 3
		if randf() < 0.35:
			points = 3
	
	if points > 0:
		Score(points, gs)
	
	if points == attempt:
		made = "made"
	description = "%s - %spt shot %s" % [GetTeamID(), attempt, made]
	
	Turnover()
	next = HalfcourtGSE


func Score(points: int, gs: GameSimulator):
	if team == gs.TEAM.HOME:
		home_score_add = points
	else:
		away_score_add = points


#func NextGSEType():
#	return HalfcourtGSE
