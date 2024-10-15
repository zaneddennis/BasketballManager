extends RefCounted
class_name GameResult


var home_score = 0
var away_score = 0

# other stats and stuff here


func _init(h: int, a: int):
	home_score = h
	away_score = a


func _to_string():
	return "<GameResult:%d - %d>" % [home_score, away_score]
