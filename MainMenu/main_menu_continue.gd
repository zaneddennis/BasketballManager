extends MainMenuContent


signal load_continue


func Activate(mm: MainMenu):
	super(mm)
	
	$MMSaveSummaryWidget.Activate(mm.saves[0])


func _on_load_pressed(slot_name: String):
	load_continue.emit()
