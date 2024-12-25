extends Node


const DEBUG_SAVE = "new_career_2024-12-23"  # TODO: redo and retest some of this?
const SAVES_LOCATION = "user://save_data"

@export var height_gen_curve: Curve  # because implementing a skewed normal in Godot would be painful

# positions
const PG = 0
const SG = 1
const SF = 2
const PF = 3
const C = 4
