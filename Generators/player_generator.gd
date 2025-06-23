extends RefCounted
class_name PlayerGenerator

# TODO: there is definitely a cleaner way to write all this


var height_curve: Curve
#const INITIAL_POLISH: float = 0.7  # for HS


func _init():
	height_curve = Constants.height_gen_curve


func GenerateRecruit(id: int, character_id: int, age: int = 0) -> Dictionary:
	var jersey = randi() % 100
	
	var height_pct = randf()
	var height = roundi(height_curve.sample(height_pct))  # [68, 86]
	var weight_from_height = roundi(4.627 * height - 147.473)
	var weight = weight_from_height + roundi(randfn(0, 7.5))
	
	# penalize maximum athleticism if above 6'6
	# TODO: weight penalties (BMI?)
	var _height_pen = clampf(inverse_lerp(78, 86, height), 0.0, 1.0)
	
	var _height_adj = clampf(inverse_lerp(68, 86, height), 0.0, 1.0)
	var _weight_adj = clampf(inverse_lerp(150, 275, weight), 0.0, 1.0)
	var _grit_adj = clampf(randfn(0.0, 0.2), 0.0, 1.0)
	
	var _pot_overall = _gen_attribute(0.6, 0.1)
	var _pot_athleticism = _gen_attribute(_pot_overall)
	var _pot_technical = _gen_attribute(_pot_overall)
	var _pot_mental = _gen_attribute(_pot_overall, 0.1)
	
	# some types of attributes develop earlier/later
	# e.g. most athleticism comes early, but mental is slower to develop
	var _pol_overall = _gen_attribute(0.7)  # as HS
	var _pol_athleticism = _est_polish(age, _pol_overall * 1.2) # as current
	var _pol_strength = _est_polish(age, _pol_overall * 0.8)
	var _pol_technical = _est_polish(age, _pol_overall * 0.9)
	var _pol_shooting = _est_polish(age, _pol_overall * 0.8)
	var _pol_mental = _est_polish(age, _pol_overall * 0.7)
	
	var max_agility = _gen_attribute(_pot_athleticism - 0.2 * _height_pen)
	var max_strength = _gen_attribute(0.4 * _pot_athleticism + 0.6 * _weight_adj)
	var max_vertical = _gen_attribute(0.8 * _height_adj + 0.2 * _pot_athleticism)
	var max_endurance = _gen_attribute(_pot_athleticism, 0.1)
	
	var max_ball_handling = _gen_attribute(_pot_technical)
	var max_passing = _gen_attribute(_pot_technical)
	var max_finishing = _gen_attribute(_pot_technical, 0.1)
	var max_shooting = _gen_attribute(_pot_technical, 0.1)
	var max_rebounding = _gen_attribute(_pot_technical, 0.1)
	var max_perimeter_defense = _gen_attribute(0.7 * _pot_technical + 0.3 * _grit_adj, 0.1)
	var max_interior_defense = _gen_attribute(0.7 * _pot_technical + 0.3 * _grit_adj, 0.1)
	
	var max_vision = _gen_attribute(_pot_mental, 0.1)
	var max_off_the_ball = _gen_attribute(_pot_mental, 0.1)
	var max_positioning = _gen_attribute(_pot_mental, 0.1)
	
	return {
		"ID": id,
		"CharacterID": character_id,
		"Eligibility": Constants.YEARS[age],
		"Height": height,
		"Weight": weight,
		
		"Agility": _gen_attribute(max_agility * _pol_athleticism),
		"Strength": _gen_attribute(max_strength * _pol_strength),
		"VerticalReach": _gen_attribute(max_vertical * _pol_athleticism),
		"Endurance": _gen_attribute(max_endurance * _pol_athleticism),
		
		"BallHandling": _gen_attribute(max_ball_handling * _pol_technical),
		"Passing": _gen_attribute(max_passing * _pol_technical),
		"Finishing": _gen_attribute(max_finishing * _pol_technical),
		"Shooting": _gen_attribute(max_shooting * _pol_shooting),
		"Rebounding": _gen_attribute(max_rebounding * _pol_technical),
		"PerimeterDefense": _gen_attribute(max_perimeter_defense * _pol_technical),
		"InteriorDefense": _gen_attribute(max_interior_defense * _pol_technical),
		
		"Vision": _gen_attribute(max_vision * _pol_mental),
		"OffTheBall": _gen_attribute(max_off_the_ball * _pol_mental),
		"Positioning": _gen_attribute(max_positioning * _pol_mental),
		
		"PotentialAgility": max_agility,
		"PotentialStrength": max_strength,
		"PotentialVerticalReach": max_vertical,
		"PotentialEndurance": max_endurance,
		
		"PotentialBallHandling": max_ball_handling,
		"PotentialPassing": max_passing,
		"PotentialFinishing": max_finishing,
		"PotentialShooting": max_shooting,
		"PotentialRebounding": max_rebounding,
		"PotentialPerimeterDefense": max_perimeter_defense,
		"PotentialInteriorDefense": max_interior_defense,
		
		"PotentialVision": max_vision,
		"PotentialOffTheBall": max_off_the_ball,
		"PotentialPositioning": max_positioning
	}


func _gen_attribute(center: float, dev: float = 0.05) -> float:
	return clamp(
		randfn(
			center, dev
		),
		0.0, 1.0
	)


func _est_polish(age: int, initial: float) -> float:
	if age == 0:
		return initial
	else:
		return _est_polish(age - 1, initial) + 0.4 * (1.0 - _est_polish(age - 1, initial))
