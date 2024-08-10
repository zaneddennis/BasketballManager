extends ColorRect


func Activate(title: String, content: Array[String]):
	$Panel/VBoxContainer/Header.text = title
	
	for n in $Panel/VBoxContainer.get_children():
		if not n.name in ["Header", "HSeparator"]:
			n.queue_free()
	
	for c in content:
		var l = Label.new()
		l.text = c
		$Panel/VBoxContainer.add_child(l)
	
	show()


func Close():
	hide()


func _on_button_pressed():
	Close()
