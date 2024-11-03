extends GameSimulationEvent
class_name HalfcourtGSE


func _init(gs: GameSimulator):
	super(gs)
	team = gs.possession
	Simulate(gs)
	
func Simulate(gs: GameSimulator):
	time_elapsed = randi_range(5, min(30, gs.time))
	description = "%s - Halfcourt offense" % GetTeamID()
	
	# ???
	
	next = ShotGSE
