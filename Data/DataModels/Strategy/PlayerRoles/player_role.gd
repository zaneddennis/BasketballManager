extends Resource
class_name PlayerRole


@export var display_name: String
@export var display_abb: String
@export var valid_positions: String  # XX,XX,XX, etc


@export_group("Priorities With Ball")
@export var prio_shoot: float = 0.0
@export var prio_perimeter_dribble: float = 0.0
@export var prio_drive: float = 0.0
@export var prio_pass: float = 0.0

@export_group("Priorities Without Ball")
@export var prio_set_up: float = 0.0
@export var prio_post_up: float = 0.0
@export var prio_interior_cut: float = 0.0

@export_group("Evaluation Ratios")
@export var eval_agility: float = 0.0
@export var eval_strength: float = 0.0
@export var eval_vertical_reach: float = 0.0
@export var eval_ball_handling: float = 0.0
@export var eval_finishing: float = 0.0
@export var eval_shooting: float = 0.0
@export var eval_rebounding: float = 0.0
@export var eval_perimeter_defense: float = 0.0
@export var eval_interior_defense: float = 0.0
@export var eval_vision: float = 0.0
@export var eval_off_the_ball: float = 0.0
@export var eval_positioning: float = 0.0


func get_unique_id():
	return resource_path.split("/")[-1].split(".")[0]


func _to_string() -> String:
	return "<PlayerRole:%s>" % get_unique_id()
