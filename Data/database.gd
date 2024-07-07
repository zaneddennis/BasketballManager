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
	# Violating unique constraint??? But still appearing to be working???
	database.insert_rows(
		"Conferences",
		[
			{"ID": "XII", "Name": "Big 12 Conference", "ShortName": "Big 12", "Prestige": 9},
			{"ID": "ACC", "Name": "Atlantic Coast Conference", "ShortName": "ACC", "Prestige": 9},
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
			{"ID": 8, "City": "Nashville", "State": "TN", "StateName": "Tennessee", "Population": 2000000}
		]
	)
	database.insert_rows(
		"Schools",
		[
			{"ID": "SMU", "FullName": "Southern Methodist University", "ShortName": "SMU", "Mascot": "Mustangs", "Location": 1, "Conference": "ACC", "PrestigeHistoric": 3, "PrestigeCurrent": 4},
			{"ID": "TCU", "FullName": "Texas Cocaine University", "ShortName": "TCU", "Mascot": "Horny Toads", "Location": 1, "Conference": "XII", "PrestigeHistoric": 4, "PrestigeCurrent": 6},
			{"ID": "TUL", "FullName": "University of Tulsa", "ShortName": "Tulsa", "Mascot": "Golden Hurricane", "Location": 2, "Conference": "OTH", "PrestigeHistoric": 4, "PrestigeCurrent": 3},
			{"ID": "BAY", "FullName": "Baylor University", "ShortName": "Baylor", "Mascot": "Bears", "Location": 3, "Conference": "XII", "PrestigeHistoric": 8, "PrestigeCurrent": 9},
			{"ID": "OKLA", "FullName": "University of Oklahoma", "ShortName": "Oklahoma", "Mascot": "Sooners", "Location": 5, "Conference": "XII", "PrestigeHistoric": 8, "PrestigeCurrent": 7},
			{"ID": "STEV", "FullName": "Stevens Institute of Technology", "ShortName": "Stevens", "Mascot": "Ducks", "Location": 6, "Conference": "OTH", "PrestigeHistoric": 1, "PrestigeCurrent": 1},
			{"ID": "PETE", "FullName": "Saint Peter's University", "ShortName": "St Peter's", "Mascot": "Peacocks", "Location": 7, "Conference": "OTH", "PrestigeHistoric": 1, "PrestigeCurrent": 2},
			{"ID": "VAND", "FullName": "Vanderbilt University", "ShortName": "Vanderbilt", "Mascot": "Commodores", "Location": 8, "Conference": "ACC", "PrestigeHistoric": 5, "PrestigeCurrent": 5}
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
			{"Year": 2003, "Name": "Mike", "Freq": 1.0},
			{"Year": 2003, "Name": "Liam", "Freq": 1.0},
			{"Year": 2004, "Name": "John", "Freq": 1.0},
			{"Year": 2004, "Name": "Mike", "Freq": 1.0},
			{"Year": 2004, "Name": "Liam", "Freq": 1.0},
			{"Year": 2005, "Name": "John", "Freq": 1.0},
			{"Year": 2005, "Name": "Mike", "Freq": 1.0},
			{"Year": 2005, "Name": "Liam", "Freq": 1.0},
			{"Year": 2006, "Name": "John", "Freq": 1.0},
			{"Year": 2006, "Name": "Mike", "Freq": 1.0},
			{"Year": 2006, "Name": "Liam", "Freq": 1.0},
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
			{"Surname": "Thomas", "Per100k": 256.34}
		]
	)
	
	var test_query = GetConference("XII")
	print("Test Query: ", test_query)
	print("---")


func Get(query: String):
	database.query(query)
	var result = database.query_result
	return result


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


func GetColumnAsList(table: String, column: String, order_by: String) -> Array:
	database.query("SELECT %s FROM %s ORDER BY %s" % [column, table, order_by])
	var result = database.query_result
	var ret_val = []
	for row in result:
		ret_val.append(row[column])
	return ret_val

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
