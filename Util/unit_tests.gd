extends Node


func _ready():
	var p1 = Player.New(
			Character.New("Jared", "Butler"), 0, 12, 75, 195,
			14, 9, 6,
			14, 16, 17, 10, 16, 8,
			15, 18, 16
	)
	var p2 = Player.New(
			Character.New("Davion", "Mitchell"), 1, 45, 74, 205,
					16, 11, 7,
					13, 14, 15, 11, 19, 12,
					13, 15, 16
				)
	var p3 = Player.New(
					Character.New("Flo", "Thamba"), 4, 0, 82, 245,
					9, 12, 15,
					4, 7, 5, 13, 6, 12,
					3, 6, 10
				)
	
	var evaluator = Evaluator.new()
	var e = evaluator.EvaluatePlayer(p1, Database._player_roles[1], 0)
	print(e)
	e = evaluator.EvaluatePlayer(p2, Database._player_roles[1], 0)
	print(e)
	e = evaluator.EvaluatePlayer(p3, Database._player_roles[1], 0)
	print(e)


func TestArrayIsIn():
	var a = [
		CourtLocation.new(CourtLocation.HALF.WEST, CourtLocation.AREA.PERIMETER, CourtLocation.SIDE.LEFT),
		CourtLocation.new(CourtLocation.HALF.WEST, CourtLocation.AREA.PERIMETER, CourtLocation.SIDE.RIGHT),
		CourtLocation.new(CourtLocation.HALF.WEST, CourtLocation.AREA.PERIMETER, CourtLocation.SIDE.CENTER)
	]
	var cl = CourtLocation.new(CourtLocation.HALF.WEST, CourtLocation.AREA.PERIMETER, CourtLocation.SIDE.LEFT)
	assert(Util.List.IsIn(a, cl))


func TestCourtLocConstructor():
	var clo = CourtLocation.FromStrs("EAST", "PERIMETER", "CENTER")
	print(clo)
	assert(clo.Equals(
		CourtLocation.new(CourtLocation.HALF.EAST, CourtLocation.AREA.PERIMETER, CourtLocation.SIDE.CENTER)
	))
	var cld = CourtLocation.FromStrs("EAST", "PERIMETER", "CENTER", 0.5)
	print(cld)
	assert(clo.Equals(
		CourtLocation.new(CourtLocation.HALF.EAST, CourtLocation.AREA.PERIMETER, CourtLocation.SIDE.CENTER, 0.5)
	))


func TestOpenCourtLocs():
	print("TEST GameSimulator.OpenCourtLocations():")
	var baylor = School.New(
					"BAY", "Baylor", "Bears",
					Color("#154734"), Color("#FFB81C")
				)
	var zaga = School.New(
				"ZAGA", "Gonzaga", "Bulldogs",
				Color("#041E42"), Color("#C8102E")
			)
	
	var g = Game.New(
		Team.New(
			baylor, [
				Player.New(
					Character.New("Jared", "Butler"), 0, 12, 75, 195,
					14, 9, 6,
					14, 16, 17, 10, 16, 8,
					15, 18, 16, baylor
				),
				Player.New(
					Character.New("Davion", "Mitchell"), 1, 45, 74, 205,
					16, 11, 7,
					13, 14, 15, 11, 19, 12,
					13, 15, 16, baylor
				),
				Player.New(
					Character.New("Macio", "Teague"), 2, 31, 76, 195,
					14, 7, 8,
					13, 12, 16, 8, 12, 8,
					12, 17, 12, baylor
				),
				Player.New(
					Character.New("Mark", "Vital"), 3, 11, 77, 250,
					12, 17, 10,
					6, 9, 5, 18, 11, 16,
					8, 7, 15, baylor
				),
				Player.New(
					Character.New("Flo", "Thamba"), 4, 0, 82, 245,
					9, 12, 15,
					4, 7, 5, 13, 6, 12,
					3, 6, 10, baylor
				),
				Player.New(
					Character.New("Adam", "Flagler"), 5, 10, 75, 180,
					13, 6, 7,
					14, 13, 14, 8, 11, 6,
					12, 17, 12, baylor
				),
				Player.New(
					Character.New("Jonathan", "Tchamwa Tchatchoua"), 6, 23, 80, 245,
					11, 12, 14,
					5, 12, 6, 13, 7, 14,
					6, 8, 10, baylor
				),
				Player.New(
					Character.New("Matthew", "Mayer"), 7, 24, 81, 225,
					8, 11, 13,
					9, 11, 12, 11, 8, 8,
					7, 10, 10, baylor
				)
			]
		),
		Team.New(
			zaga, [
				Player.New(
					Character.New("Jalen", "Suggs"), 8, 1, 76, 205,
					18, 7, 8,
					17, 15, 13, 12, 10, 7,
					14, 9, 8, zaga
				),
				Player.New(
					Character.New("Joel", "Ayayi"), 9, 11, 77, 180,
					14, 5, 8,
					13, 13, 12, 10, 10, 10,
					10, 10, 10, zaga
				),
				Player.New(
					Character.New("Andrew", "Nembhard"), 10, 3, 77, 195,
					15, 7, 9,
					14, 10, 14, 10, 10, 10,
					10, 12, 10, zaga
				),
				Player.New(
					Character.New("Corey", "Kispert"), 11, 24, 79, 220,
					10, 11, 13,
					10, 12, 16, 10, 9, 12,
					6, 13, 9, zaga
				),
				Player.New(
					Character.New("Drew", "Timme"), 12, 2, 82, 235,
					6, 11, 17,
					5, 15, 7, 14, 5, 11,
					7, 9, 12, zaga
				),
				Player.New(
					Character.New("Aaron", "Cook"), 13, 10, 73, 180,
					13, 4, 6,
					11, 10, 10, 10, 8, 8,
					8, 8, 8, zaga
				),
				Player.New(
					Character.New("Anton", "Watson"), 14, 22, 80, 225,
					9, 12, 13,
					6, 12, 6, 10, 6, 8,
					8, 8, 8, zaga
				)
			]
		)
	)
	var gs = GameSimulator.new(g)
	
	# test empty
	print("\tTest Empty:")
	var result = gs.GetOpenLocations(CourtLocation.HALF.WEST)
	print("\t\t", result)
	assert(len(result) == 17)
	print("---\n")
	
	# test not empty
	print("\tTest Not Empty:")
	gs.player_locs[0] = CourtLocation.new(CourtLocation.HALF.WEST, CourtLocation.AREA.PERIMETER, CourtLocation.SIDE.RIGHT)
	gs.player_locs[1] = CourtLocation.new(CourtLocation.HALF.WEST, CourtLocation.AREA.VALVE, CourtLocation.SIDE.CENTER)
	gs.player_locs[2] = CourtLocation.new(CourtLocation.HALF.WEST, CourtLocation.AREA.BLOCK, CourtLocation.SIDE.RIGHT)
	result = gs.GetOpenLocations(CourtLocation.HALF.WEST)
	print("\t\t", result)
	assert(len(result) == 14)
	assert(not CourtLocation.new(CourtLocation.HALF.WEST, CourtLocation.AREA.PERIMETER, CourtLocation.SIDE.RIGHT) in result)
	print("---")
	
	# test area filter
	print("\tTest Area Filter:")
	result = gs.GetOpenLocations(CourtLocation.HALF.WEST, [CourtLocation.AREA.BLOCK, CourtLocation.AREA.FT_LINE])
	print("\t\t", result)
	assert(len(result) == 4)
	print("---")
	
	# test planned movements
	print("\tTest Planned Movements:")
	result = gs.GetOpenLocations(
		CourtLocation.HALF.WEST,
		[CourtLocation.AREA.PERIMETER, CourtLocation.AREA.CORNER],
		[CourtLocation.FromStrs("WEST", "PERIMETER", "RIGHT")],  # from
		[CourtLocation.FromStrs("WEST", "CORNER", "RIGHT")],  # to
	)
	print("\t\t",result)
	assert(not Util.List.IsIn(result, CourtLocation.FromStrs("WEST", "CORNER", "RIGHT")))  # to
	assert(Util.List.IsIn(result, CourtLocation.FromStrs("WEST", "PERIMETER", "RIGHT")))  # from
