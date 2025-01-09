extends RefCounted
class_name PlayerGenerator


var height_curve: Curve


func _init():
	height_curve = Constants.height_gen_curve


func GeneratePlayer(id: int, character_id: int) -> Dictionary:
	var jersey = randi() % 100  # 0-99
	
	var height_pct = randf()
	var height = roundi(height_curve.sample(height_pct))
	
	var weight_from_height = roundi(4.627 * height - 147.473)
	var weight = weight_from_height + roundi(randfn(0, 7.5))
	
	var height_adj = (height - 76) / 3.0
	var weight_adj = (weight - 205) / 10.0
	
	var _athleticism_adj = randfn(0, 3)
	var _technical_adj = randfn(0 - height_adj + 0.5 * _athleticism_adj, 3)
	var _grit_adj = randfn(0, 3)
	var _mental_adj = randfn(0, 4)
	
	var agility = _gen_attribute(8 - weight_adj + _athleticism_adj, 3) #clamp(roundi(randfn(8 - weight_adj, 3)), 1, 20)
	var strength = _gen_attribute(8 + 2 * weight_adj + 0.5 * _athleticism_adj, 2) #clamp(roundi(randfn(8 + 2 * weight_adj, 2)), 1, 20)
	var vertical = _gen_attribute(8 + 3 * height_adj + _athleticism_adj, 2) #clamp(roundi(randfn(8 + 3 * height_adj, 2)), 1, 20)
	
	var handling = _gen_attribute(8 + 2 * _technical_adj - height_adj, 2.5) #clamp(randfn(8 + 2 * _technical_adj - height_adj, 3), 1, 20)  # todo: roundi
	var finishing = _gen_attribute(8 + _technical_adj + 0.5 * height_adj, 3) #clamp(randfn(8 + _technical_adj + 0.5 * height_adj, 2), 1, 20)
	var shooting = _gen_attribute(8 + _technical_adj, 3.5) #clamp(randfn(8 + _technical_adj, 4), 1, 20)
	var rebounding = _gen_attribute(8 + _grit_adj, 3)
	var perimeter = _gen_attribute(8 + _grit_adj, 3)
	var interior = _gen_attribute(8 + _grit_adj, 3)
	
	var vision = _gen_attribute(8 + 2 * _mental_adj, 2)
	var off_the_ball = _gen_attribute(8 + _mental_adj, 3)
	var positioning = _gen_attribute(8 + _mental_adj, 3)
	
	return {
		"ID": id,
		"CharacterID": character_id,
		"Eligibility": "FR",  # not implemented yet
		"Height": height,
		"Weight": weight,
		"Agility": agility,
		"Strength": strength,
		"VerticalReach": vertical,
		"BallHandling": handling,
		"Finishing": finishing,
		"Shooting": shooting,
		"Rebounding": rebounding,
		"PerimeterDefense": perimeter,
		"InteriorDefense": interior,
		"Vision": vision,
		"OffTheBall": off_the_ball,
		"Positioning": positioning
	}


func _gen_attribute(center: float, dev: float):
	return clamp(
		roundi(
			randfn(
				center, dev
			)
		),
		1, 20
	)
