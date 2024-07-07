extends Panel
class_name MainMenuSaveSummaryWidget


var slot_name: String


signal load_pressed(slot_name: String)


func Activate(save_data: Dictionary):
	slot_name = save_data["slot_name"]
	
	$VBoxContainer/SlotName.text = save_data["slot_name"]
	$VBoxContainer/Character.text = save_data["character_name"]
	$VBoxContainer/School.text = save_data["current_school"]
	$VBoxContainer/Timestamp.text = Timestamp.FromStr(save_data["current_time"]).ToPrettyStr()
	$VBoxContainer/LastPlayed.text = "Last Played: " + save_data["last_played"]


func _on_button_pressed():
	load_pressed.emit(slot_name)
