extends Object
class_name Util


class List:
	static func Mean(a: Array[float]) -> float:
		var total = a.reduce(func(accum, x): return accum + x)
		return total / float(len(a))
	
	static func Zip(arrays: Array[Array]) -> Array[Array]:
		for a in arrays:
			assert (len(a) == len(arrays[0]))
		
		var l = len(arrays[0])
		
		var result: Array[Array] = []
		for i in range(l):
			var row = []
			for a in arrays:
				row.append(a[i])
			result.append(row)
		
		return result
