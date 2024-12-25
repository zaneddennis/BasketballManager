extends Page


signal name_hovered


var team: Team


func Activate(id: Variant = null):
	super(id)
	
	team = Team.FromDatabase(id)
	
	var p = 0
	for w in _get_lineup_widgets():
		if p < len(team.players):
			var player: Player = team.strategy.lineup[p]
			w.Activate(player)
			if not w.lineup_changed.is_connected(_on_lineup_changed):
				w.lineup_changed.connect(_on_lineup_changed)
			if not w.name_hovered.is_connected(_on_hover_player_name):
				w.name_hovered.connect(_on_hover_player_name)
		else:
			w.hide()
		p += 1


func Save():
	var lineup: Array[Player] = []
	for w in _get_lineup_widgets():
		if w.visible:
			lineup.append(w.player)
	
	var strategy = Strategy.New(lineup)
	team.strategy = strategy
	team.UpdateDatabase()


func _get_lineup_widgets() -> Array[PlayerLineupSlotWidget]:
	var result: Array[PlayerLineupSlotWidget] = []
	
	for n in $Content/HBoxContainer/Lineup/VBox.get_children():
		if n is PlayerLineupSlotWidget:
			result.append(n as PlayerLineupSlotWidget)
	
	return result


func _on_lineup_changed():
	Save()

func _on_hover_player_name(pos: Vector2, pla: Player):
	name_hovered.emit(pos, pla)
