extends Node


var database: SQLite
var active_game: ActiveGame


func _ready():
	database = SQLite.new()
	# todo: replace this with slot variable
	database.path = "user://save_data/career0/database.db"
	database.open_db()
	
	var test_query = GetSchool("BAY")
	print("Test Query: ", test_query)
	print("---")


func GetCharacter(id: int):
	database.query("SELECT * FROM Characters WHERE ID = %d" % id)
	var result = database.query_result
	assert(len(result) == 1)
	return result[0]

func GetCoach(id: int):
	database.query("SELECT * FROM Coaches WHERE ID = %d" % id)
	var result = database.query_result
	assert(len(result) == 1)
	return result[0]

func GetConference(id: String):
	database.query("SELECT * FROM Conferences WHERE ID = '%s'" % id)
	var result = database.query_result
	assert(len(result) == 1)
	return result[0]

func GetGame(id: int):
	database.query("SELECT * FROM Games WHERE ID = %d" % id)
	var result = database.query_result
	assert(len(result) == 1)
	return result[0]

func GetLocation(id: int):
	database.query("SELECT ID, City, State FROM Locations WHERE ID = %d" % id)
	var result = database.query_result
	assert(len(result) == 1)
	return result[0]

func GetPlayer(id: int):
	database.query("SELECT * FROM Players WHERE ID = %d" % id)
	var result = database.query_result
	assert(len(result) == 1)
	return result[0]

func GetSchool(id: String):
	database.query("SELECT * FROM Schools WHERE ID = '%s'" % id)
	var result = database.query_result
	assert(len(result) == 1)
	return result[0]

func GetTeam(id: int):
	database.query("SELECT * FROM Teams WHERE ID = %d" % id)
	var result = database.query_result
	assert(len(result) == 1)
	return result[0]

func GetTeamFromSchool(school_id: String, year: int):
	database.query("SELECT * FROM Teams WHERE SchoolID = '%s' AND Year = %d" % [school_id, year])
	var result = database.query_result
	assert(len(result) == 1)
	return result[0]


func GetConferenceStandings(conference: String) -> DataFrame:
	database.query(
		"""
		SELECT ShortName, Schools.ID, Wins, Losses
		FROM Teams JOIN Schools
			ON Teams.SchoolID = Schools.ID
		WHERE Conference = '%s'
		""" % conference
	)
	var result = database.query_result
	var result_as_rows = []
	for row in result:
		result_as_rows.append(row.values())
	return DataFrame.New(
		result_as_rows,
		["Team", "Team_tablemeta", "W", "L"]
	)
