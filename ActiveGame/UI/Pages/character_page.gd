extends "res://ActiveGame/UI/Pages/page.gd"


var character: Character


func Activate(id):
	assert(id)
	super(id)
	
	character = Character.FromDatabase(id)
	
	$Content/Summary/HBoxContainer/VBoxContainer/Name.text = character.FullName()
	# todo: role
	$Content/Summary/HBoxContainer/VBoxContainer/Age.text = str(character.Age()) + " y.o."
	
	# if Character has a Coach, render Coach section
	# etc for other Character archetypes
	
	if character.coach_id:
		$Content/Coach.show()
		
		var coach = Coach.FromDatabase(character.coach_id)
		
		# summary
		var school_id = coach.school_id
		if school_id:
			var school = School.FromDatabase(school_id)
			$Content/Summary/HBoxContainer/VBoxContainer/School.text = school.short_name
			$Content/Summary/HBoxContainer/VBoxContainer/Role.text = "Head Coach"
		else:
			$Content/Summary/HBoxContainer/VBoxContainer/School.text = "Unemployed"
		
		# attributes
		for attribute in ["Offense", "Defense", "Mental", "Physical", "Technical", "Evaluation", "Scouting"]:
			var ojw = get_node("Content/Coach/Attributes/VBoxContainer/" + attribute)
			ojw.right = str(coach.get(attribute.to_lower()))
		
		# biography
		$Content/Coach/Biography/VBoxContainer/Hometown.right = character.hometown.ToPrettyStr()
		$Content/Coach/Biography/VBoxContainer/AlmaMater.right = character.alma_mater.short_name  # coaches should always have an AM


func Refresh():
	super()
	Activate(character.id)
