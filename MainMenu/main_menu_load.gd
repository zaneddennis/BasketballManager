extends MainMenuContent


signal load_load(slot_name: String)


var SaveSummaryWidget = preload("res://MainMenu/mm_save_summary_widget.tscn")


func Activate(mm: MainMenu):
	super(mm)
	
	for n in $ScrollContainer/VBoxContainer.get_children():
		n.queue_free()
	
	for save in mm.saves:
		var widget: MainMenuSaveSummaryWidget = SaveSummaryWidget.instantiate()
		widget.size_flags_horizontal = SIZE_EXPAND_FILL
		widget.Activate(save)
		$ScrollContainer/VBoxContainer.add_child(widget)
		widget.load_pressed.connect(_on_load_pressed)


func _on_load_pressed(slot_name: String):
	load_load.emit(slot_name)
