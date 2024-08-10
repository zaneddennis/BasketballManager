extends RefCounted
class_name GameSimulator


func _init():
	pass


func Simulate() -> GameResult:
	var result = GameResult.new(randi_range(60, 80), randi_range(60, 80))
	
	return result


func Tick():
	pass
