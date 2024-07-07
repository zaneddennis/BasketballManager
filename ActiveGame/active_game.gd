extends Node
class_name ActiveGame


@onready var ui: UIManager = $UI
@onready var page_manager: PageManager = $UI/PageManager

var slot: String

var current_time: Timestamp
const PLAYER_ID: int = 1


func _ready():
	if TransitionManager.slot:
		print("Loading Game: ", TransitionManager.slot)
		slot = TransitionManager.slot
	else:
		print("Loading Game From Debug: ", Constants.DEBUG_SAVE)
		slot = Constants.DEBUG_SAVE
	
	LoadFromSlot(slot)
	
	if TransitionManager.first_time_load:
		NewSeason()
	
	Database.active_game = self
	Database.Activate(slot)
	
	page_manager.RenderHome()
	
	ui.Refresh(self)


func LoadFromSlot(slot: String):
	var filepath_partial = Constants.SAVES_LOCATION + "/" + slot
	
	var save_meta_dict = JSON.parse_string(
			FileAccess.open(filepath_partial + "/meta.json", FileAccess.READ).get_as_text()
		)
	#player_id = save_meta_dict["player_id"]
	
	var game_status_dict = JSON.parse_string(
		FileAccess.open(filepath_partial + "/game_status.json", FileAccess.READ).get_as_text()
	)
	current_time = Timestamp.FromStr(game_status_dict["current_time"])


func NewSeason():
	print("New Season!")
	
	# create new Teams
	var school_ids = Database.GetColumnAsList("Schools", "ID", "ID")
	var rows = []
	for i in range(len(school_ids)):
		var school_id = school_ids[i]
		rows.append(
			{"ID": i + 1, "SchoolID": school_id, "Year": current_time.year, "Wins": 0, "Losses": 0}
		)
	Database.database.insert_rows("Teams", rows)


func NewPhase():
	pass


# updates meta.json and game_status.json
func SaveGame():
	var filepath_partial = Constants.SAVES_LOCATION + "/" + slot
	
	var meta_file = FileAccess.open(filepath_partial + "/meta.json", FileAccess.READ)
	var meta_dict = JSON.parse_string(meta_file.get_as_text())
	meta_dict["last_played"] = Time.get_date_string_from_system()
	meta_file = FileAccess.open(filepath_partial + "/meta.json", FileAccess.WRITE)  # to overwrite
	meta_file.store_string(JSON.stringify(meta_dict, "\t", false))
	
	var gs_file = FileAccess.open(filepath_partial + "/game_status.json", FileAccess.READ)
	var gs_dict = JSON.parse_string(gs_file.get_as_text())
	gs_dict["current_time"] = current_time.ToISOStr()
	gs_file = FileAccess.open(filepath_partial + "/game_status.json", FileAccess.WRITE)
	gs_file.store_string(JSON.stringify(gs_dict, "\t", false))


func _on_ui_advance_time():
	var new_things = current_time.Advance()
	if "season" in new_things:
		NewSeason()
	if "phase" in new_things:
		NewPhase()
	
	SaveGame()
	
	ui.Refresh(self)
