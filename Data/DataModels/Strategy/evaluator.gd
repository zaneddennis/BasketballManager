extends RefCounted
class_name Evaluator


var pref_physical: float = 0.0
var pref_technical: float = 0.0
var pref_mental: float = 0.0


func EvaluatePlayer(player: Player, at_role: PlayerRole, coach: Coach) -> float:  # [0, 1]
	var sum = 0.0
	
	var total_ratio = 0.0
	for attr in Player.ALL_ATTRS:
		var val = player.get(attr) / 20.0
		var ratio = at_role.get("eval_" + attr)
		
		sum += (val * ratio)
		total_ratio += ratio
	
	seed(player.id + coach.id)
	var skill_val = 1.0 - (coach.evaluation / 20.0)
	var skill_adj = randfn(0.0, skill_val / 4.0)
	
	return (sum / total_ratio) + skill_adj
