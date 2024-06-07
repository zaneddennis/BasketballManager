extends "res://ActiveGame/UI/Pages/page.gd"


var school: School


func Activate(id):
	assert(id)
	super(id)

	school = School.FromDatabase(id)
	
	$Content/Summary/HBoxContainer/VBoxContainer/Core/Name.text = school.full_name.to_upper()
	$Content/Summary/HBoxContainer/VBoxContainer/Core/Mascot.text = school.mascot
	$Content/Summary/HBoxContainer/VBoxContainer/Core/Location.text = school.location.ToPrettyStr()
	$Content/Summary/HBoxContainer/VBoxContainer/Conference.text = school.conference.id

func Refresh():
	super()
	Activate(school.id)
