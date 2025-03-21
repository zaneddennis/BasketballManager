extends Node


const VERBOSITY = 1

var database: SQLite
var active_game: ActiveGame

# Resource DBs
@export var _player_roles: Array[PlayerRole]  # input
var player_roles: Dictionary  # actual


func Create(slot: String):
	DirAccess.copy_absolute(
		"res://Data/ReferenceData/template.db",
		"user://save_data/%s/database.db" % slot
	)


# TODO: separate ActivateDebug() function with different sample data
func Activate(slot: String):
	database = SQLite.new()
	database.path = "user://save_data/%s/database.db" % slot
	database.open_db()
	
	# fill data
	# TODO: replace this with loading from data files
	# Violating unique constraint??? But still appearing to be working???
	#	Okay I figured this out; it's because this function is getting called both in active_game.gd and in main_menu_new.gd
	database.insert_rows(
		"Conferences",
		[
			{"ID": "XII", "Name": "Big 12 Conference", "ShortName": "Big 12", "Prestige": 10},
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
			{"ID": 6, "City": "Houston", "State": "TX", "StateName": "Texas", "Population": 2500000},
			{"ID": 7, "City": "Jersey City", "State": "NJ", "StateName": "New Jersey", "Population": 1000000},
			{"ID": 8, "City": "Nashville", "State": "TN", "StateName": "Tennessee", "Population": 1000000},
			{"ID": 9, "City": "Lexington", "State": "KY", "StateName": "Kentucky", "Population": 320000},
			{"ID": 10, "City": "Tuscaloosa", "State": "AL", "StateName": "Alabama", "Population": 100000},
			{"ID": 11, "City": "Auburn", "State": "AL", "StateName": "Alabama", "Population": 80000},
			{"ID": 12, "City": "Knoxville", "State": "TN", "StateName": "Tennessee", "Population": 200000},
			{"ID": 13, "City": "Stillwater", "State": "OK", "StateName": "Oklahoma", "Population": 50000},
			{"ID": 14, "City": "Chapel Hill", "State": "NC", "StateName": "North Carolina", "Population": 60000},
			{"ID": 15, "City": "Raleigh", "State": "NC", "StateName": "North Carolina", "Population": 500000},
			{"ID": 16, "City": "Durham", "State": "NC", "StateName": "North Carolina", "Population": 300000},
			{"ID": 17, "City": "Austin", "State": "TX", "StateName": "Texas", "Population": 1000000},
			{"ID": 18, "City": "Tucson", "State": "AZ", "StateName": "Arizona", "Population": 500000},
			{"ID": 19, "City": "Lubbock", "State": "TX", "StateName": "Texas", "Population": 250000},
			{"ID": 20, "City": "Ames", "State": "IA", "StateName": "Iowa", "Population": 65000},
			{"ID": 21, "City": "Provo", "State": "UT", "StateName": "Utah", "Population": 113000},
			{"ID": 22, "City": "Lawrence", "State": "KS", "StateName": "Kansas", "Population": 96000},
			{"ID": 23, "City": "Manhattan", "State": "KS", "StateName": "Kansas", "Population": 54000},
			{"ID": 24, "City": "Morgantown", "State": "WV", "StateName": "West Virginia", "Population": 30000},
			{"ID": 25, "City": "Orlando", "State": "FL", "StateName": "Florida", "Population": 321000},
			{"ID": 26, "City": "Salt Lake City", "State": "UT", "StateName": "Utah", "Population": 210000},
			{"ID": 27, "City": "Tempe", "State": "AZ", "StateName": "Arizona", "Population": 190000},
			{"ID": 28, "City": "Cincinnati", "State": "OH", "StateName": "Ohio", "Population": 311000},
			{"ID": 29, "City": "Boulder", "State": "CO", "StateName": "Colorado", "Population": 106000},
			{"ID": 30, "City": "Spokane", "State": "WA", "StateName": "Washington", "Population": 229000},
			{"ID": 31, "City": "Corvallis", "State": "OR", "StateName": "Oregon", "Population": 61000},
			{"ID": 32, "City": "Pullman", "State": "WA", "StateName": "Washington", "Population": 33000},
			{"ID": 33, "City": "Wichita", "State": "KS", "StateName": "Kansas", "Population": 396000},
			{"ID": 34, "City": "Denton", "State": "TX", "StateName": "Texas", "Population": 158000},
			{"ID": 35, "City": "Gainesville", "State": "FL", "StateName": "Florida", "Population": 146000},
			{"ID": 36, "City": "Tallahassee", "State": "FL", "StateName": "Florida", "Population": 202000},
			{"ID": 37, "City": "Coral Gables", "State": "FL", "StateName": "Florida", "Population": 48000},
			{"ID": 38, "City": "Athens", "State": "GA", "StateName": "Georgia", "Population": 129000},
			{"ID": 39, "City": "Atlanta", "State": "GA", "StateName": "Georgia", "Population": 511000},
			{"ID": 40, "City": "Columbia", "State": "SC", "StateName": "South Carolina", "Population": 142000},
			{"ID": 41, "City": "Clemson", "State": "SC", "StateName": "South Carolina", "Population": 18000},
			{"ID": 42, "City": "Charlottesville", "State": "VA", "StateName": "Virginia", "Population": 45000},
			{"ID": 43, "City": "Blacksburg", "State": "VA", "StateName": "Virginia", "Population": 45000},
			{"ID": 44, "City": "College Station", "State": "TX", "StateName": "Texas", "Population": 125000},
			{"ID": 45, "City": "Fayetteville", "State": "AR", "StateName": "Arkansas", "Population": 102000}
		]
	)
	database.insert_rows(
		"Schools",
		[
			{"ID": "SMU", "FullName": "Southern Methodist University", "ShortName": "SMU", "Mascot": "Mustangs", "Location": 1, "Conference": "ACC", "PrestigeHistoric": 3, "PrestigeCurrent": 4, "Color1": "#0033A0", "Color2": "#C8102E"},
			{"ID": "TCU", "FullName": "Texas Cocaine University", "ShortName": "TCU", "Mascot": "Horny Toads", "Location": 1, "Conference": "XII", "PrestigeHistoric": 4, "PrestigeCurrent": 6, "Color1": "#4D1979", "Color2": "#A3A9AC"},
			{"ID": "TUL", "FullName": "University of Tulsa", "ShortName": "Tulsa", "Mascot": "Golden Hurricane", "Location": 2, "Conference": "OTH", "PrestigeHistoric": 4, "PrestigeCurrent": 3, "Color1": "#002D72", "Color2": "#C8102E"},
			{"ID": "BAY", "FullName": "Baylor University", "ShortName": "Baylor", "Mascot": "Bears", "Location": 3, "Conference": "XII", "PrestigeHistoric": 7, "PrestigeCurrent": 9, "Color1": "#154734", "Color2": "#FFB81C"},
			{"ID": "OKLA", "FullName": "University of Oklahoma", "ShortName": "Oklahoma", "Mascot": "Sooners", "Location": 5, "Conference": "SEC", "PrestigeHistoric": 8, "PrestigeCurrent": 7, "Color1": "#841617", "Color2": "#FDF9D8"},
			{"ID": "TEX", "FullName": "University of Texas at Austin", "ShortName": "Texas", "Mascot": "Longhorns", "Location": 17, "Conference": "SEC", "PrestigeHistoric": 7, "PrestigeCurrent": 7, "Color1": "bf5700", "Color2": "ffffff"},
			{"ID": "PETE", "FullName": "Saint Peter's University", "ShortName": "St Peter's", "Mascot": "Peacocks", "Location": 7, "Conference": "OTH", "PrestigeHistoric": 1, "PrestigeCurrent": 2, "Color1": "#003C71", "Color2": "#0072CE"},
			{"ID": "VAND", "FullName": "Vanderbilt University", "ShortName": "Vanderbilt", "Mascot": "Commodores", "Location": 8, "Conference": "SEC", "PrestigeHistoric": 5, "PrestigeCurrent": 5, "Color1": "#000000", "Color2": "#866d4b"},
			{"ID": "KTKY", "FullName": "University of Kentucky", "ShortName": "Kentucky", "Mascot": "Wildcats", "Location": 9, "Conference": "SEC", "PrestigeHistoric": 9, "PrestigeCurrent": 7, "Color1": "#0033a0", "Color2": "#FFFFFF"},
			{"ID": "BAMA", "FullName": "University of Alabama", "ShortName": "Alabama", "Mascot": "Crimson Tide", "Location": 10, "Conference": "SEC", "PrestigeHistoric": 6, "PrestigeCurrent": 7, "Color1": "#9e1b32", "Color2": "#828a8f"},
			{"ID": "AUB", "FullName": "Auburn University", "ShortName": "Auburn", "Mascot": "Tigers", "Location": 11, "Conference": "SEC", "PrestigeHistoric": 6, "PrestigeCurrent": 6, "Color1": "#0C2340", "Color2": "#E87722"},
			{"ID": "TENN", "FullName": "University of Tennessee", "ShortName": "Tennessee", "Mascot": "Volunteers", "Location": 12, "Conference": "SEC", "PrestigeHistoric": 6, "PrestigeCurrent": 7, "Color1": "#FF8200", "Color2": "#58595b"},
			{"ID": "OKST", "FullName": "Oklahoma State University", "ShortName": "Oklahoma State", "Mascot": "Cowboys", "Location": 13, "Conference": "XII", "PrestigeHistoric": 8, "PrestigeCurrent": 6, "Color1": "#FF7300", "Color2": "#000000"},
			{"ID": "UNC", "FullName": "University of North Carolina", "ShortName": "North Carolina", "Mascot": "Tar Heels", "Location": 14, "Conference": "ACC", "PrestigeHistoric": 10, "PrestigeCurrent": 10, "Color1": "#7BAFD4", "Color2": "#FFFFFF"},
			{"ID": "NCST", "FullName": "North Carolina State University", "ShortName": "NC State", "Mascot": "Wolfpack", "Location": 15, "Conference": "ACC", "PrestigeHistoric": 6, "PrestigeCurrent": 7, "Color1": "#CC0000", "Color2": "#000000"},
			{"ID": "DUKE", "FullName": "Duke University", "ShortName": "Duke", "Mascot": "Blue Devils", "Location": 16, "Conference": "ACC", "PrestigeHistoric": 10, "PrestigeCurrent": 10, "Color1": "#003087", "Color2": "#ffffff"},
			{"ID": "HOU", "FullName": "University of Houston", "ShortName": "Houston", "Mascot": "Cougars", "Location": 6, "Conference": "XII", "PrestigeHistoric": 6, "PrestigeCurrent": 8, "Color1": "#C8102E", "Color2": "#B2B4B2"},
			{"ID": "ZONA", "FullName": "University of Arizona", "ShortName": "Arizona", "Mascot": "Wildcats", "Location": 18, "Conference": "XII", "PrestigeHistoric": 9, "PrestigeCurrent": 8, "Color1": "#CC0033", "Color2": "#003366"},
			{"ID": "TECH", "FullName": "Texas Tech University", "ShortName": "Texas Tech", "Mascot": "Red Raiders", "Location": 19, "Conference": "XII", "PrestigeHistoric": 7, "PrestigeCurrent": 8, "Color1": "#CC0033", "Color2": "#003366"},
			{"ID": "IAST", "FullName": "Iowa State University", "ShortName": "Iowa State", "Mascot": "Cyclones", "Location": 20, "Conference": "XII", "PrestigeHistoric": 7, "PrestigeCurrent": 8, "Color1": "#C8102E", "Color2": "#F1BE48"},
			{"ID": "BYU", "FullName": "Brigham Young University", "ShortName": "BYU", "Mascot": "Cougars", "Location": 21, "Conference": "XII", "PrestigeHistoric": 7, "PrestigeCurrent": 6, "Color1": "#002E5D", "Color2": "#0062B8"},
			{"ID": "KAN", "FullName": "University of Kansas", "ShortName": "Kansas", "Mascot": "Jayhawks", "Location": 22, "Conference": "XII", "PrestigeHistoric": 10, "PrestigeCurrent": 10},
			{"ID": "KSST", "FullName": "Kansas State University", "ShortName": "Kansas State", "Mascot": "Wildcats", "Location": 23, "Conference": "XII", "PrestigeHistoric": 6, "PrestigeCurrent": 6},
			{"ID": "WVU", "FullName": "University of West Virginia", "ShortName": "West Virginia", "Mascot": "Mountaineers", "Location": 24, "Conference": "XII", "PrestigeHistoric": 6, "PrestigeCurrent": 6},
			{"ID": "UCF", "FullName": "University of Central Florida", "ShortName": "UCF", "Mascot": "Knights", "Location": 25, "Conference": "XII", "PrestigeHistoric": 3, "PrestigeCurrent": 4},
			{"ID": "UTAH", "FullName": "University of Utah", "ShortName": "Utah", "Mascot": "Utes", "Location": 26, "Conference": "XII", "PrestigeHistoric": 6, "PrestigeCurrent": 6},
			{"ID": "AZST", "FullName": "Arizona State University", "ShortName": "Arizona State", "Mascot": "Sun Devils", "Location": 27, "Conference": "XII", "PrestigeHistoric": 6, "PrestigeCurrent": 6},
			{"ID": "CIN", "FullName": "University of Cincinnati", "ShortName": "Cincinnati", "Mascot": "Bearcats", "Location": 28, "Conference": "XII", "PrestigeHistoric": 7, "PrestigeCurrent": 6},
			{"ID": "COLO", "FullName": "University of Colorado", "ShortName": "Colorado", "Mascot": "Buffaloes", "Location": 29, "Conference": "XII", "PrestigeHistoric": 6, "PrestigeCurrent": 5},
			{"ID": "ZAGA", "FullName": "Gonzaga University", "ShortName": "Gonzaga", "Mascot": "Bulldogs", "Location": 30, "Conference": "OTH", "PrestigeHistoric": 8, "PrestigeCurrent": 9},
			{"ID": "ORST", "FullName": "Oregon State University", "ShortName": "Oregon State", "Mascot": "Beavers", "Location": 31, "Conference": "OTH", "PrestigeHistoric": 6, "PrestigeCurrent": 5},
			{"ID": "WAST", "FullName": "Washington State University", "ShortName": "Washington State", "Mascot": "Cougars", "Location": 32, "Conference": "OTH", "PrestigeHistoric": 6, "PrestigeCurrent": 5},
			{"ID": "WICH", "FullName": "Wichita State University", "ShortName": "Wichita State", "Mascot": "Shockers", "Location": 33, "Conference": "OTH", "PrestigeHistoric": 7, "PrestigeCurrent": 6},
			{"ID": "RICE", "FullName": "Rice University", "ShortName": "Rice", "Mascot": "Owls", "Location": 6, "Conference": "OTH", "PrestigeHistoric": 3, "PrestigeCurrent": 3},
			{"ID": "UNT", "FullName": "University of North Texas", "ShortName": "North Texas", "Mascot": "Mean Green", "Location": 34, "Conference": "OTH", "PrestigeHistoric": 3, "PrestigeCurrent": 3},
			{"ID": "FLA", "FullName": "University of Florida", "ShortName": "Florida", "Mascot": "Gators", "Location": 35, "Conference": "SEC", "PrestigeHistoric": 7, "PrestigeCurrent": 7, "Color1": "#0021A5", "Color2": "#FA4616"},
			{"ID": "FSU", "FullName": "Florida State University", "ShortName": "Florida State", "Mascot": "Seminoles", "Location": 36, "Conference": "ACC", "PrestigeHistoric": 6, "PrestigeCurrent": 6},
			{"ID": "MIA", "FullName": "University of Miami (FL)", "ShortName": "Miami (FL)", "Mascot": "Hurricanes", "Location": 37, "Conference": "ACC", "PrestigeHistoric": 6, "PrestigeCurrent": 8},
			{"ID": "UGA", "FullName": "University of Georgia", "ShortName": "Georgia", "Mascot": "Bulldogs", "Location": 38, "Conference": "SEC", "PrestigeHistoric": 6, "PrestigeCurrent": 6, "Color1": "#BA0C2F", "Color2": "#000000"},
			{"ID": "GT", "FullName": "Georgia Institute of Technology", "ShortName": "Georgia Tech", "Mascot": "Yellowjackets", "Location": 39, "Conference": "ACC", "PrestigeHistoric": 5, "PrestigeCurrent": 5},
			{"ID": "SCAR", "FullName": "University of South Carolina", "ShortName": "South Carolina", "Mascot": "Gamecocks", "Location": 40, "Conference": "SEC", "PrestigeHistoric": 6, "PrestigeCurrent": 6, "Color1": "#73000A", "Color2": "#000000"},
			{"ID": "CLEM", "FullName": "Clemson University", "ShortName": "Clemson", "Mascot": "Tigers", "Location": 41, "Conference": "ACC", "PrestigeHistoric": 6, "PrestigeCurrent": 7},
			{"ID": "UVA", "FullName": "University of Virginia", "ShortName": "Virginia", "Mascot": "Cavaliers", "Location": 42, "Conference": "ACC", "PrestigeHistoric": 8, "PrestigeCurrent": 8},
			{"ID": "VT", "FullName": "Virginia Polytechnic Institute and State University", "ShortName": "Virginia Tech", "Mascot": "Hokies", "Location": 43, "Conference": "ACC", "PrestigeHistoric": 6, "PrestigeCurrent": 6},
			{"ID": "TAMU", "FullName": "Texas A&M University", "ShortName": "Texas A&M", "Mascot": "Aggies", "Location": 44, "Conference": "SEC", "PrestigeHistoric": 7, "PrestigeCurrent": 7, "Color1": "#500000", "Color2": "#FFFFFF"},
			{"ID": "ARK", "FullName": "University of Arkansas", "ShortName": "Arkansas", "Mascot": "Razorbacks", "Location": 45, "Conference": "SEC", "PrestigeHistoric": 6, "PrestigeCurrent": 7, "Color1": "#9D2235", "Color2": "#FFFFFF"}
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
	
	for pr: PlayerRole in _player_roles:  # TODO: sort?
		var role_id = pr.get_unique_id()
		player_roles[role_id] = pr
	
	database.verbosity_level = VERBOSITY
	
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
	print(result)
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


# TODO: are these obsolete now?
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
		SELECT ShortName, Schools.ID, Wins, Losses, ConfWins, ConfLosses, ROUND(COALESCE(ConfWins / (ConfWins * 1.0 + ConfLosses), 0.0), 3) AS ConfPct
		FROM Teams JOIN Schools
			ON Teams.SchoolID = Schools.ID
		WHERE Conference = '%s' AND YEAR = %d
		ORDER BY ConfPct DESC
		""" % [conference, active_game.current_time.year]
	)
	var result = database.query_result
	var result_as_rows = []
	for row in result:
		result_as_rows.append(row.values())
	return DataFrame.New(
		result_as_rows,
		["Team", "_tablemeta_Team", "W", "L", "ConfWins", "ConfLosses", "ConfPct"]
	)


func InsertRow(table: String, dict: Dictionary):
	database.insert_row(table, dict)

func UpdateRow(table: String, id: Variant, dict: Dictionary):
	database.update_rows(
		table,
		"id = '%s'" % id,
		dict
	)
