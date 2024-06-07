extends MainMenuContent


signal load_continue


func Activate(mm: MainMenu):  # just pass the save, not the whole MM
	super(mm)
	
	$Panel/VBoxContainer/SlotName.text = mm.saves[0]["slot_name"]


func _on_load_pressed():
	load_continue.emit()
