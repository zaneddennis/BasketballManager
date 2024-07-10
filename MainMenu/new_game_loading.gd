extends CanvasLayer


var thread: Thread

@onready var character_generator: CharacterGenerator = CharacterGenerator.new()
@onready var coach_generator: CoachGenerator = CoachGenerator.new()
@onready var player_generator: PlayerGenerator = PlayerGenerator.new()

var num_coaches: int
var num_players: int


func _ready():
	#if not TransitionManager.slot:  # if running directly in engine, set default save slot
	#	TransitionManager.slot = "new_career_datestr"
	
	$Panel/VBoxContainer/Footer/InProgress/AnimationPlayer.play("InProgress")
	
	thread = Thread.new()
	$Panel/VBoxContainer/Coaches.show()
	thread.start(ThreadGenerateCoaches)


func _complete_generate_coaches():
	thread.wait_to_finish()
	$Panel/VBoxContainer/Players.show()
	thread.start(ThreadGeneratePlayers)

func _complete_generate_players():
	thread.wait_to_finish()
	$Panel/VBoxContainer/Hire.show()
	thread.start(ThreadHireCoaches)

func _complete_hire_coaches():
	thread.wait_to_finish()
	$Panel/VBoxContainer/Recruit.show()
	thread.start(ThreadRecruitPlayers)

func _complete_recruit_players():
	thread.wait_to_finish()
	$Panel/VBoxContainer/Complete.show()
	Complete()


func Complete():
	$Panel/VBoxContainer/Footer/InProgress/AnimationPlayer.stop()
	$Panel/VBoxContainer/Footer/InProgress.hide()
	$Panel/VBoxContainer/Footer/Start.show()


func ThreadGenerateCoaches():
	print("Generating Coaches...")
	
	num_coaches = int(len(Database.GetSchoolsList()) * 1.5)
	var characters = []
	var coaches = []
	
	var next_id = 2
	for i in num_coaches:
		characters.append(character_generator.GenerateCoach(next_id + i, next_id + i))
		coaches.append(coach_generator.GenerateCoach(next_id + i, next_id + i))
	
	# save character to db
	Database.database.insert_rows("Characters", characters)
	# save coach to db
	Database.database.insert_rows("Coaches", coaches)
	
	call_deferred("_complete_generate_coaches")


func ThreadGeneratePlayers():
	print("Generating Players...")
	
	num_players = len(Database.GetSchoolsList()) * 20
	var characters = []
	var players = []
	
	var next_id = 2 + num_coaches  # num_coaches doesn't include the user Coach
	for i in num_players:
		characters.append(character_generator.GeneratePlayer(next_id + i, 1 + i))
		players.append(player_generator.GeneratePlayer(1 + i, next_id + i))
	
	Database.database.insert_rows("Characters", characters)
	Database.database.insert_rows("Players", players)
	
	call_deferred("_complete_generate_players")


func ThreadHireCoaches():
	print("Hiring Coaches...")
	var schools_list = Database.GetColumnAsList("Schools", "ID", "ID")
	var user_school = Database.GetColumnAsList("Coaches", "SchoolID", "ID")[0]
	schools_list.erase(user_school)  # user's selected school
	for i in range(num_coaches - len(schools_list)):
		schools_list.append(null)
	schools_list.shuffle()
	
	for i in range(len(schools_list)):
		var school_id = schools_list[i]
		if school_id:
			Database.database.update_rows("Coaches", "ID = %d" % (2 + i), {"SchoolID": school_id})
	
	call_deferred("_complete_hire_coaches")


func ThreadRecruitPlayers():
	print("Recruiting Players...")
	var players = Database.Get("""
		SELECT ID, _Physical, _Technical, _Mental,
			ROUND(_Physical + _Technical + _Mental, 2) AS Rating
		FROM
			(SELECT ID,
				(Agility + Strength + VerticalReach)/3.0 AS _Physical,
				(BallHandling + Finishing + Shooting + Rebounding + PerimeterDefense + InteriorDefense)/6.0 AS _Technical,
				(Vision + OffTheBall + Positioning)/3.0 AS _Mental
			FROM Players)
		ORDER BY Rating DESC
	""")
	
	var schools_list = Database.GetColumnAsList("Schools", "ID", "ID")
	var prestiges_list = Database.GetColumnAsList("Schools", "PrestigeCurrent", "ID")
	
	var counts = {}
	var priorities = {}
	for i in range(len(schools_list)):
		var id = schools_list[i]
		var p = prestiges_list[i] ** 2
		counts[id] = 0
		priorities[id] = p
	
	var destinations = []
	for i in range(len(players)):
		if len(counts) > 0:
			var school_picker = WeightedChoice.new(priorities.keys(), priorities.values())
			var school = school_picker.Pick()
			destinations.append(school)
			
			counts[school] += 1
			if counts[school] >= 12:
				counts.erase(school)
				priorities.erase(school)
	
	for i in range(len(players)):
		if i < len(destinations):
			var player_id = players[i]["ID"]
			var school_id = destinations[i]
			Database.database.update_rows("Players", "ID = %d" % player_id, {"SchoolID": school_id})
	
	call_deferred("_complete_recruit_players")


func _on_start_pressed():
	TransitionManager.first_time_load = true
	get_tree().change_scene_to_file("res://ActiveGame/active_game.tscn")
