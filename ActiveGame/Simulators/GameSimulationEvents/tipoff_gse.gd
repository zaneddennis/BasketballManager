extends GameSimulationEvent
class_name TipoffGSE


var won_by: GameSimulator.TEAM


func _init(gs: GameSimulator):
	super(gs)
	
	time_elapsed = randi_range(4, 8)
	
	won_by = GameSimulator.TEAM.values().pick_random()
	team = won_by
	possession = won_by
	
	description = "%s - Tipoff won by %s" % [GetTeamID(), GetTeamID()]


func NextGSEType():
	return HalfcourtGSE
