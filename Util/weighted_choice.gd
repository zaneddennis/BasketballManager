extends RefCounted
class_name WeightedChoice


var options: Array
var weights: Array[float]
var breakpoints: Array[float]


func _init(o: Array, w: Array):
	assert(len(o) == len(w))
	options = []
	weights = []
	
	for i in range(len(o)):
		if w[i] != 0.0:
			options.append(o[i])
			weights.append(w[i])
	
	var min_weight = float(weights.min())
	weights.assign(weights.map(func(x): return float(x)))
	weights.assign(weights.map(func(x): return x / min_weight))
	
	breakpoints = []
	var sum = 0.0
	for weight in weights:
		sum += weight
		breakpoints.append(sum)


func Pick():
	var f = randf_range(0.0, breakpoints[-1])
	for i in range(len(breakpoints)):
		var b = breakpoints[i]
		if f <= b:
			return options[i]
	
	assert(false)
