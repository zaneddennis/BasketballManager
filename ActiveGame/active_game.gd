extends Node
class_name ActiveGame


@onready var ui: UIManager = $UI
@onready var page_manager: PageManager = $UI/PageManager


var current_time: Timestamp
var player_id: int


func _ready():
	var slot = ""
	if TransitionManager.slot:
		print("Loading Game: ", TransitionManager.slot)
		slot = TransitionManager.slot
	else:
		print("Loading Game From Debug: ", Constants.DEBUG_SAVE)
		slot = Constants.DEBUG_SAVE
	
	LoadFromSlot(slot)
	
	Database.active_game = self
	
	page_manager.RenderHome()
	
	ui.Refresh(self)


func LoadFromSlot(slot: String):
	var filepath_partial = Constants.SAVES_LOCATION + "/" + slot
	
	var save_meta_dict = JSON.parse_string(
			FileAccess.open(filepath_partial + "/meta.json", FileAccess.READ).get_as_text()
		)
	player_id = save_meta_dict["player_id"]
	
	var game_status_dict = JSON.parse_string(
		FileAccess.open(filepath_partial + "/game_status.json", FileAccess.READ).get_as_text()
	)
	current_time = Timestamp.FromStr(game_status_dict["current_time"])


func _on_ui_advance_time():
	current_time.Advance()
	ui.Refresh(self)
