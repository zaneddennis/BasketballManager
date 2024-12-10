extends Node


var database: SQLite
var active_game: ActiveGame


func Create(slot: String):
	DirAccess.copy_absolute(
		"res://Data/ReferenceData/template.db",
		"user://save_data/%s/database.db" % slot
	)


func Activate(slot: String):
	database = SQLite.new()
	database.path = "user://save_data/%s/database.db" % slot
	database.open_db()
	
	# fill data
	# TODO: replace this with loading from data files
	# Violating unique constraint??? But still appearing to be working???
	database.insert_rows(
		"Conferences",
		[
			{"ID": "XII", "Name": "Big 12 Conference", "ShortName": "Big 12", "Prestige": 9},
			{"ID": "ACC", "Name": "Atlantic Coast Conference", "ShortName": "ACC", "Prestige": 9},
			{"ID": "SEC", "Name": "Southeastern Conference", "ShortName": "SEC", "Prestige": 7},
			{"ID": "OTH", "Name": "Other Conference", "ShortName": "Other", "Prestige": 4},
		]
	)
	database.insert_rows(
		"Locations",
		[
			{"ID": 1, "City": "Dallas", "State": "TX", "StateName": "Texas", "Population": 1300000},
			{"ID": 2, "City": "Tulsa", "State": "OK", "StateName": "Oklahoma", "Population": 400000},
			{"ID": 3, "City": "Waco", "State": "TX", "StateName": "Texas", "Population": 150000},
			{"ID": 4, "City": "Edmond", "State": "OK", "StateName": "Oklahoma", "Population": 100000},
			{"ID": 5, "City": "Norman", "State": "OK", "StateName": "Oklahoma", "Population": 200000},
			{"ID": 6, "City": "Hoboken", "State": "NJ", "StateName": "New Jersey", "Population": 60000},
			{"ID": 7, "City": "Jersey City", "State": "NJ", "StateName": "New Jersey", "Population": 1000000},
			{"ID": 8, "City": "Nashville", "State": "TN", "StateName": "Tennessee", "Population": 1000000},
			{"ID": 9, "City": "Lexington", "State": "KY", "StateName": "Kentucky", "Population": 320000},
			{"ID": 10, "City": "Tuscaloosa", "State": "AL", "StateName": "Alabama", "Population": 100000},
			{"ID": 11, "City": "Auburn", "State": "AL", "StateName": "Alabama", "Population": 80000},
			{"ID": 12, "City": "Knoxville", "State": "TN", "StateName": "Tennessee", "Population": 200000},
			{"ID": 13, "City": "Stillwater", "State": "OK", "StateName": "Oklahoma", "Population": 50000},
			{"ID": 14, "City": "Chapel Hill", "State": "NC", "StateName": "North Carolina", "Population": 60000},
			{"ID": 15, "City": "Raleigh", "State": "NC", "StateName": "North Carolina", "Population": 500000},
			{"ID": 16, "City": "Durham", "State": "NC", "StateName": "North Carolina", "Population": 300000}
		]
	)
	database.insert_rows(
		"Schools",
		[
			{"ID": "SMU", "FullName": "Southern Methodist University", "ShortName": "SMU", "Mascot": "Mustangs", "Location": 1, "Conference": "ACC", "PrestigeHistoric": 3, "PrestigeCurrent": 4},
			{"ID": "TCU", "FullName": "Texas Cocaine University", "ShortName": "TCU", "Mascot": "Horny Toads", "Location": 1, "Conference": "XII", "PrestigeHistoric": 4, "PrestigeCurrent": 6},
			{"ID": "TUL", "FullName": "University of Tulsa", "ShortName": "Tulsa", "Mascot": "Golden Hurricane", "Location": 2, "Conference": "OTH", "PrestigeHistoric": 4, "PrestigeCurrent": 3},
			{"ID": "BAY", "FullName": "Baylor University", "ShortName": "Baylor", "Mascot": "Bears", "Location": 3, "Conference": "XII", "PrestigeHistoric": 7, "PrestigeCurrent": 9},
			{"ID": "OKLA", "FullName": "University of Oklahoma", "ShortName": "Oklahoma", "Mascot": "Sooners", "Location": 5, "Conference": "XII", "PrestigeHistoric": 8, "PrestigeCurrent": 7},
			{"ID": "STEV", "FullName": "Stevens Institute of Technology", "ShortName": "Stevens", "Mascot": "Ducks", "Location": 6, "Conference": "OTH", "PrestigeHistoric": 1, "PrestigeCurrent": 1},
			{"ID": "PETE", "FullName": "Saint Peter's University", "ShortName": "St Peter's", "Mascot": "Peacocks", "Location": 7, "Conference": "OTH", "PrestigeHistoric": 1, "PrestigeCurrent": 2},
			{"ID": "VAND", "FullName": "Vanderbilt University", "ShortName": "Vanderbilt", "Mascot": "Commodores", "Location": 8, "Conference": "SEC", "PrestigeHistoric": 5, "PrestigeCurrent": 5},
			{"ID": "KTKY", "FullName": "University of Kentucky", "ShortName": "Kentucky", "Mascot": "Wildcats", "Location": 9, "Conference": "SEC", "PrestigeHistoric": 9, "PrestigeCurrent": 7},
			{"ID": "BAMA", "FullName": "University of Alabama", "ShortName": "Alabama", "Mascot": "Crimson Tide", "Location": 10, "Conference": "SEC", "PrestigeHistoric": 6, "PrestigeCurrent": 7},
			{"ID": "AUB", "FullName": "Auburn University", "ShortName": "Auburn", "Mascot": "Tigers", "Location": 11, "Conference": "SEC", "PrestigeHistoric": 6, "PrestigeCurrent": 6},
			{"ID": "TENN", "FullName": "University of Tennessee", "ShortName": "Tennessee", "Mascot": "Volunteers", "Location": 12, "Conference": "SEC", "PrestigeHistoric": 6, "PrestigeCurrent": 7},
			{"ID": "OKST", "FullName": "Oklahoma State University", "ShortName": "Oklahoma State", "Mascot": "Cowboys", "Location": 13, "Conference": "XII", "PrestigeHistoric": 8, "PrestigeCurrent": 6},
			{"ID": "UNC", "FullName": "University of North Carolina", "ShortName": "North Carolina", "Mascot": "Tar Heels", "Location": 14, "Conference": "ACC", "PrestigeHistoric": 10, "PrestigeCurrent": 10},
			{"ID": "NCST", "FullName": "North Carolina State University", "ShortName": "NC State", "Mascot": "Wolfpack", "Location": 15, "Conference": "ACC", "PrestigeHistoric": 6, "PrestigeCurrent": 7},
			{"ID": "DUKE", "FullName": "Duke University", "ShortName": "Duke", "Mascot": "Blue Devils", "Location": 16, "Conference": "ACC", "PrestigeHistoric": 10, "PrestigeCurrent": 10}
		]
	)
	database.insert_rows(
		"FirstNames",
		[
			{"Year": 1990, "Name": "Michael", "Freq": 1.0},
			{"Year": 1990, "Name": "Christopher", "Freq": 1.0},
			{"Year": 1990, "Name": "Matthew", "Freq": 1.0},
			{"Year": 1991, "Name": "Michael", "Freq": 1.0},
			{"Year": 1991, "Name": "Christopher", "Freq": 1.0},
			{"Year": 1991, "Name": "Matthew", "Freq": 1.0},
			{"Year": 1992, "Name": "Michael", "Freq": 1.0},
			{"Year": 1992, "Name": "Christopher", "Freq": 1.0},
			{"Year": 1992, "Name": "Matthew", "Freq": 1.0},
			{"Year": 1993, "Name": "Michael", "Freq": 1.0},
			{"Year": 1993, "Name": "Christopher", "Freq": 1.0},
			{"Year": 1993, "Name": "Matthew", "Freq": 1.0},
			{"Year": 1994, "Name": "Michael", "Freq": 1.0},
			{"Year": 1994, "Name": "Christopher", "Freq": 1.0},
			{"Year": 1994, "Name": "Matthew", "Freq": 1.0},
			{"Year": 1995, "Name": "Michael", "Freq": 1.0},
			{"Year": 1995, "Name": "Matthew", "Freq": 1.0},
			{"Year": 1995, "Name": "Christopher", "Freq": 1.0},
			{"Year": 2003, "Name": "John", "Freq": 1.0},
			{"Year": 2003, "Name": "Michael", "Freq": 1.0},
			{"Year": 2003, "Name": "Liam", "Freq": 1.0},
			{"Year": 2003, "Name": "Jacob", "Freq": 1.0},
			{"Year": 2003, "Name": "Joshua", "Freq": 1.0},
			{"Year": 2003, "Name": "Matthew", "Freq": 1.0},
			{"Year": 2003, "Name": "Andrew", "Freq": 1.0},
			{"Year": 2003, "Name": "Joseph", "Freq": 1.0},
			{"Year": 2003, "Name": "Ethan", "Freq": 1.0},
			{"Year": 2003, "Name": "Daniel", "Freq": 1.0},
			{"Year": 2003, "Name": "Christopher", "Freq": 1.0},
			{"Year": 2003, "Name": "Anthony", "Freq": 1.0}
		]
	)
	database.insert_rows(
		"LastNames",
		[
			{"Surname": "Smith", "Per100k": 828.19},
			{"Surname": "Johnson", "Per100k": 655.24},
			{"Surname": "Williams", "Per100k": 550.97},
			{"Surname": "Brown", "Per100k": 487.16},
			{"Surname": "Jones", "Per100k": 483.24},
			{"Surname": "Garcia", "Per100k": 395.32},
			{"Surname": "Miller", "Per100k": 393.74},
			{"Surname": "Davis", "Per100k": 378.45},
			{"Surname": "Rodriguez", "Per100k": 371.19},
			{"Surname": "Wilson", "Per100k": 271.84},
			{"Surname": "Anderson", "Per100k": 265.92},
			{"Surname": "Thomas", "Per100k": 256.34},
			{"Surname": "Taylor", "Per100k": 254.67},
			{"Surname": "Moore", "Per100k": 245.57},
			{"Surname": "Jackson", "Per100k": 240.05},
			{"Surname": "Martin", "Per100k": 238.19},
			{"Surname": "Thompson", "Per100k": 225.32}
		]
	)
	
	var test_query = GetItem("Conferences", "XII")
	print("Test Query: ", test_query)
	print("---")


# any arbitrary query
func Get(query: String) -> Array[Dictionary]:
	database.query(query)
	var result = database.query_result
	return result

# any arbitrary query
func GetDataFrame(query: String) -> DataFrame:
	database.query(query)
	var result = database.query_result
	var result_as_rows = []
	
	if len(result) > 0:
		for row in result:
			result_as_rows.append(row.values())
		return DataFrame.New(
			result_as_rows,
			result[0].keys()
		)
	else:
		return DataFrame.New([], [])

# get one row of a table based on its ID
func GetItem(table: String, id: Variant) -> Dictionary:
	if id is int:
		database.query("SELECT * FROM %s WHERE ID = %s" % [table, id])
	elif id is String:
		database.query("SELECT * FROM %s WHERE ID = '%s'" % [table, id])
	else:
		print(typeof(id))
		assert(false)
	
	var result = database.query_result
	assert(len(result) == 1)
	return result[0]

func GetColumnAsList(table: String, column: String, order_by: String, where: String = "") -> Array:
	if where:  # todo: clean this up to not have the if branch, make order_by optional as well
		database.query("SELECT %s FROM %s WHERE %s ORDER BY %s" % [column, table, where, order_by])
	else:
		database.query("SELECT %s FROM %s ORDER BY %s" % [column, table, order_by])
	var result = database.query_result
	var ret_val = []
	for row in result:
		ret_val.append(row[column])
	return ret_val

# get a single "cell" from the database
func GetValue(query: String) -> Variant:
	database.query(query)
	var qr = database.query_result
	return qr[0][qr[0].keys()[0]]


"""func GetCharacter(id: int):
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

func GetTeam(id: String):
	database.query("SELECT * FROM Teams WHERE ID = '%s'" % id)
	var result = database.query_result
	assert(len(result) == 1)
	return result[0]"""


func GetFirstNamesForYear(year: int):
	database.query("SELECT Name, Freq FROM FirstNames WHERE Year == %d" % year)
	var names = []
	var freqs = []
	for row in database.query_result:
		names.append(row["Name"])
		freqs.append(row["Freq"])
	return [names, freqs]

func GetLastNames():
	database.query("SELECT Surname, Per100k FROM LastNames")
	var names = []
	var freqs = []
	for row in database.query_result:
		names.append(row["Surname"])
		freqs.append(row["Per100k"])
	return [names, freqs]

func GetLocationFromNames(city: String, state: String):
	database.query("SELECT * FROM Locations WHERE City = '%s' AND State = '%s'" % [city, state])
	var result = database.query_result
	assert(len(result) == 1)
	return result[0]

func GetTeamFromSchool(school_id: String, year: int):
	database.query("SELECT * FROM Teams WHERE SchoolID = '%s' AND Year = %d" % [school_id, year])
	var result = database.query_result
	assert(len(result) == 1)
	return result[0]


func GetSchoolsList() -> Array[String]:
	database.query("SELECT ShortName FROM Schools ORDER BY ShortName")
	var result = database.query_result
	var ret_val: Array[String] = []
	for row in result:
		ret_val.append(row["ShortName"])
	return ret_val

func GetStatesList() -> Array[String]:
	database.query("SELECT DISTINCT State FROM Locations ORDER BY State")
	var result = database.query_result
	var ret_val: Array[String] = []
	for row in result:
		ret_val.append(row["State"])
	return ret_val

func GetCitiesInState(state: String) -> Array[String]:
	database.query("SELECT City FROM Locations WHERE State = '%s' ORDER BY City" % state)
	var result = database.query_result
	var ret_val: Array[String] = []
	for row in result:
		ret_val.append(row["City"])
	
	return ret_val


func GetConferenceStandings(conference: String) -> DataFrame:
	database.query(
		"""
		SELECT ShortName, Schools.ID, Wins, Losses, ROUND(COALESCE(Wins / (Wins * 1.0 + Losses), 0.0), 3) AS Pct
		FROM Teams JOIN Schools
			ON Teams.SchoolID = Schools.ID
		WHERE Conference = '%s' AND YEAR = %d
		ORDER BY Pct DESC
		""" % [conference, active_game.current_time.year]
	)
	var result = database.query_result
	var result_as_rows = []
	for row in result:
		result_as_rows.append(row.values())
	return DataFrame.New(
		result_as_rows,
		["Team", "_tablemeta_Team", "W", "L", "Pct"]
	)
