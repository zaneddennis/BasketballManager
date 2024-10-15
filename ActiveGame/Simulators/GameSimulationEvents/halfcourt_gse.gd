extends GameSimulationEvent
class_name HalfcourtGSE


func _init(gs: GameSimulator):
	super(gs)
	
	team = gs.possession
	
	time_elapsed = randi_range(5, min(30, gs.time))
	description = "%s - Halfcourt offense" % GetTeamID()


func NextGSEType():
	"""var roll = randf()
	
	if roll < 0.9:
		return ShotGSE
	else:
		return HalfcourtGSE"""
	return ShotGSE
