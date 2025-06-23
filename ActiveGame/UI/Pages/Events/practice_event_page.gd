extends EventPage
class_name PracticeEventPage


var PLANS = {
	Timestamp.PHASE.OFFSEASON: "",
	Timestamp.PHASE.PRESEASON: "",
	Timestamp.PHASE.REGULAR_SEASON: "",
}


var complete = false


func Activate(_id):
	print("Activating Practice")
	complete = false
	$Content/VBox/HBox/Results/Lift/GridContainer.hide()
	
	var phase = Database.active_game.current_time.phase
	var phase_str = Timestamp.PHASE.keys()[phase].capitalize()
	$Content/VBox/HBox/Plan/Type.text = "Practice Type: " + phase_str
	
	var plan = PLANS[phase]
	
	show()


func _on_complete_pressed():
	if not complete:
		complete = true
		$Content/VBox/HBox/Results/Lift/GridContainer.show()
		$Content/VBox/Complete.text = "Conclude Practice"
	elif complete:
		event_completed.emit(self)
