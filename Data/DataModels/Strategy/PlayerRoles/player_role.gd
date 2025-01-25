extends Resource
class_name PlayerRole


@export var display_name: String
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


"""@export_group("Positioning Ratios")
@export var pos_valve: float = 0.0
@export var pos_perimeter: float = 0.0
@export var pos_cutting: float = 0.0
@export var pos_high_post: float = 0.0
@export var pos_low_post: float = 0.0
@export var pos_midrange: float = 0.0

@export_group("Priorities With Ball")  # in neutral HCO state
@export var prio_pass: float = 0.0
@export var prio_drive: float = 0.0
@export var prio_pick: float = 0.0
@export var prio_iso: float = 0.0
@export var prio_shoot: float = 0.0

@export_group("Priorities Without Ball")
@export var prio_valve: float = 0.0
@export var prio_perimeter_cut: float = 0.0
@export var prio_set_up: float = 0.0
@export var prio_cut: float = 0.0
@export var prio_post_up: float = 0.0
@export var prio_set_pick: float = 0.0"""


func get_unique_id():
	return resource_path.split("/")[-1].split(".")[0]


func _to_string() -> String:
	return "<PlayerRole:%s>" % get_unique_id()
