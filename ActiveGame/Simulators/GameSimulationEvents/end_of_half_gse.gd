extends GameSimulationEvent
class_name EndOfHalfGSE


func _init(gs: GameSimulator, config: Dictionary = {}):
	super(gs, config)
	
	time_elapsed = gs.time
	description = "END OF HALF"
