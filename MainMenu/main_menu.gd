extends CanvasLayer
class_name MainMenu


var saves = []


func _ready():
	# read in save metas
	saves = GetSaves()
	
	ActivateContent($Content/Continue)


func ActivateContent(content: MainMenuContent):
	for c: MainMenuContent in $Content.get_children():
		c.Close()
	
	content.Activate(self)


func GetSaves() -> Array:
	var saves_dir = DirAccess.open(Constants.SAVES_LOCATION)
	
	var result = []
	for save_name in saves_dir.get_directories():
		if save_name != "_debug":
			var save_meta = JSON.parse_string(
				FileAccess.open(
					Constants.SAVES_LOCATION + "/" + save_name + "/meta.json", FileAccess.READ
				).get_as_text()
			)
			var save_status = JSON.parse_string(
				FileAccess.open(
					Constants.SAVES_LOCATION + "/" + save_name + "/game_status.json", FileAccess.READ
				).get_as_text()
			)
			
			if save_meta and save_status:
				var save_data = save_meta.duplicate()
				save_data.merge(save_status)
				result.append(save_data)
	
	result.sort_custom(func(a, b): return a["last_played"] > b["last_played"])
	
	return result


func LoadGame(slot_name: String):
	TransitionManager.slot = slot_name
	get_tree().change_scene_to_file("res://ActiveGame/active_game.tscn")

func StartNewGame(slot_name: String):
	TransitionManager.slot = slot_name
	get_tree().change_scene_to_file("res://MainMenu/new_game_loading.tscn")


func _on_exit_pressed():
	get_tree().quit()

func _on_continue_pressed():
	ActivateContent($Content/Continue)

func _on_new_pressed():
	ActivateContent($Content/New)

func _on_load_pressed():
	ActivateContent($Content/Load)

func _on_options_pressed():
	ActivateContent($Content/Options)


func _on_continue_load_continue():
	LoadGame(saves[0]["slot_name"])

func _on_new_start(slot_name: String):
	StartNewGame(slot_name)

func _on_load_load_load(slot_name):
	LoadGame(slot_name)
