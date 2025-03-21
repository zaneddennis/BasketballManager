extends MainMenuContent


signal new_start(slot_name: String)


@onready var sequence = [
	$World, $Character, $Finalize
]
var sequence_ix = -1
var states_list: Array[String]

var slot_name: String

var character: Character
var coach: Coach


func Activate(mm: MainMenu):
	super(mm)
	CloseAll()
	sequence_ix = -1
	ActivateNext()


func CloseAll():
	for n in sequence:
		n.hide()


func ActivateNext():
	CloseAll()
	sequence_ix += 1
	call("Activate" + sequence[sequence_ix].name)

func ActivateWorld():
	$World/VBoxContainer/Content/Slot/LineEdit.text = "new_career_" + Time.get_date_string_from_system()
	$World.show()

func ActivateCharacter():
	slot_name = $World/VBoxContainer/Content/Slot/LineEdit.text
	CreateSaveSlot()
	
	states_list = Database.GetStatesList()
	FillBirthYears()
	FillStates()
	FillCities(states_list[0])
	FillAlmaMaters()
	$Character.show()

func ActivateFinalize():
	# create Character and Coach
	character = Character.new()
	coach = Coach.new()
	character.id = 1
	coach.id = 1
	coach.character = character
	
	# character
	character.coach_id = 1
	character.first = $Character/VBoxContainer/Content/Character/FirstName/LineEdit.text
	character.last = $Character/VBoxContainer/Content/Character/LastName/LineEdit.text
	
	var birth_ob = $Character/VBoxContainer/Content/Character/Birth/OptionButton
	var birth_ix = birth_ob.get_selected_id()
	character.birth = int(birth_ob.get_item_text(birth_ix))
	
	var city_selection = $Character/VBoxContainer/Content/Character/Hometown/HBoxContainer/City
	var state_selection = $Character/VBoxContainer/Content/Character/Hometown/HBoxContainer/State
	character.hometown = Location.FromDatabase(  # this is hella inefficient
		Database.GetLocationFromNames(
			city_selection.get_item_text(city_selection.get_selected_id()),
			state_selection.get_item_text(state_selection.get_selected_id())
		)["ID"]
	)
	character.alma_mater = School.FromDatabase($Character/VBoxContainer/Content/Character/AlmaMater/OptionButton.get_selected_metadata())
	
	# coach
	coach.offense = $Character/VBoxContainer/Content/Coach/Offense/SpinBox.value
	coach.defense = $Character/VBoxContainer/Content/Coach/Defense/SpinBox.value
	coach.mental = $Character/VBoxContainer/Content/Coach/Mental/SpinBox.value
	coach.physical = $Character/VBoxContainer/Content/Coach/Physical/SpinBox.value
	coach.technical = $Character/VBoxContainer/Content/Coach/Technical/SpinBox.value
	coach.evaluation = $Character/VBoxContainer/Content/Coach/Evaluation/SpinBox.value
	coach.scouting = $Character/VBoxContainer/Content/Coach/Scouting/SpinBox.value

	var school_selection = $Finalize/VBoxContainer/Content/SchoolSelect
	school_selection.clear()
	var schools_list = Database.GetSchoolsList()
	var school_ids = Database.GetColumnAsList("Schools", "ID", "ShortName")
	for i in range(len(schools_list)):
		var school = schools_list[i]
		var id = school_ids[i]
		school_selection.add_item(school)
		school_selection.set_item_metadata(i, id)
	
	$Finalize.show()


func FillBirthYears():
	var year_selection = $Character/VBoxContainer/Content/Character/Birth/OptionButton
	for year in range(1995, 1960-1, -1):
		year_selection.add_item(str(year))


func FillStates():
	var state_selection = $Character/VBoxContainer/Content/Character/Hometown/HBoxContainer/State
	for state in states_list:
		state_selection.add_item(state)


func FillCities(state: String):
	var cities_state = Database.GetCitiesInState(state)
	
	var city_selection = $Character/VBoxContainer/Content/Character/Hometown/HBoxContainer/City
	city_selection.clear()
	for city in cities_state:
		city_selection.add_item(city)

func FillAlmaMaters():
	var ams = Database.GetSchoolsList()
	var school_ids = Database.GetColumnAsList("Schools", "ID", "ShortName")
	var am_selection = $Character/VBoxContainer/Content/Character/AlmaMater/OptionButton
	am_selection.clear()
	#for am in ams:
	for i in range(len(ams)):
		var am = ams[i]
		var school_id = school_ids[i]
		am_selection.add_item(am)
		am_selection.set_item_metadata(i, school_id)


func CreateSaveSlot():
	var dir = DirAccess.open("user://save_data")
	dir.make_dir(slot_name)
	
	var meta_file = FileAccess.open("user://save_data/%s/meta.json" % slot_name, FileAccess.WRITE)
	var meta = JSON.stringify({
		"slot_name": slot_name,
		"last_played": Time.get_date_string_from_system(),
	}, "\t", false)
	meta_file.store_string(meta)
	
	var gs_file = FileAccess.open("user://save_data/%s/game_status.json" % slot_name, FileAccess.WRITE)
	var game_status = JSON.stringify(
		{
			"current_time": "2025-0-0-0",
			"processed_events_yet": false,
			"simmed_games_yet": false
		},
		"\t", false
	)
	gs_file.store_string(game_status)
	
	Database.Create(slot_name)
	Database.Activate(slot_name)


func _on_state_item_selected(index):
	var state_selection = $Character/VBoxContainer/Content/Character/Hometown/HBoxContainer/State
	var state = state_selection.get_item_text(index)
	FillCities(state)


func _on_next_pressed():
	ActivateNext()


func _on_start_game_pressed():
	character.ToDatabase()
	var school_ob = $Finalize/VBoxContainer/Content/SchoolSelect
	#coach.school_id = school_ob.get_selected_metadata()
	coach.school = School.FromDatabase(school_ob.get_selected_metadata())
	coach.ToDatabase()
	
	var filepath_partial = Constants.SAVES_LOCATION + "/" + slot_name
	var gs_file = FileAccess.open(filepath_partial + "/game_status.json", FileAccess.READ)
	var gs_dict = JSON.parse_string(gs_file.get_as_text())
	gs_dict["character_name"] = character.FullName()
	gs_dict["current_school"] = school_ob.get_item_text(school_ob.get_selected_id())
	gs_file = FileAccess.open(filepath_partial + "/game_status.json", FileAccess.WRITE)
	gs_file.store_string(JSON.stringify(gs_dict, "\t", false))
	
	new_start.emit(slot_name)
