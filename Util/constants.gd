extends Node


const DEBUG_SAVE = "END_REG_SEASON_TEST_9"
const SAVES_LOCATION = "user://save_data"

@export var height_gen_curve: Curve  # because implementing a skewed normal in Godot would be painful

# positions
const PG = 0
const SG = 1
const SF = 2
const PF = 3
const C = 4

# years
const YEARS = ["HS", "FR", "SO", "JR", "SR"]
