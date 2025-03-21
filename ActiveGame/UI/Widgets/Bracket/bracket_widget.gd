extends ScrollContainer
class_name BracketWidget


var BracketCellScene = preload("res://ActiveGame/UI/Widgets/Bracket/bracket_cell.tscn")


enum TEAM_COUNT{TEAMS4=4, TEAMS8=8, TEAMS16=16, TEAMS32=32}


#@export var num_teams: TEAM_COUNT = TEAM_COUNT.TEAMS16
#var num_rounds: int
var tournament: Tournament


func _ready() -> void:
	Render()

func Render(active: bool = false):
	for n in $Background.get_children():
		if n.name == "NotYet":
			n.visible = !active
		else:
			n.queue_free()
	
	if not active:
		return
	
	print("Rendering bracket with %d rounds for %d teams" % [tournament.num_rounds, tournament.num_teams])
	print(tournament.teams)
	
	# total size
	$Background.custom_minimum_size = Vector2(
		192 * (tournament.num_rounds + 1),
		24 * ((3 * tournament.num_teams / 2) + (tournament.num_teams / 2) - 1)
	)
	
	# cells
	var game_ix = 0
	for r in range(1, tournament.num_rounds+1):
		print("\tRendering Round %d"  % r)
		var num_cells = tournament.num_teams / (2 ** r)
		
		for i in num_cells:
			var cell: BracketCell = BracketCellScene.instantiate()
			$Background.add_child(cell)
			
			cell.ActivateV2(i, r, tournament, game_ix)
			game_ix += 1
