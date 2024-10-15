extends GameSimulationEvent
class_name EndOfHalfGSE


func _init(gs: GameSimulator):
	super(gs)
	
	time_elapsed = gs.time
	description = "END OF HALF"
