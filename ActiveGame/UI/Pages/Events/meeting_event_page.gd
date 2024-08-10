extends EventPage


func _on_complete_pressed():
	event_completed.emit(self)
