extends RefCounted
class_name Statline


var points: int = 0
var rebounds: int = 0
var assists: int = 0

var shots_made: int = 0
var shots_att: int = 0
var threes_made: int = 0
var threes_att: int = 0


func Add(delta: Statline):
	points += delta.points
	rebounds += delta.rebounds
	assists += delta.assists
	
	shots_made += delta.shots_made
	shots_att += delta.shots_att
	threes_made += delta.threes_made
	threes_att += delta.threes_att


func _to_string() -> String:
	return "<Statline:%d/%d/%d>" % [points, rebounds, assists]
