extends PanelContainer


func _ready():
	if get_tree().current_scene == self:
		ActivateDebug()


func Activate(pos: Vector2, player: Player):
	position = pos
	$MarginContainer/VBoxContainer/Bio/Texts/Name.text = player.character.FullName()
	$MarginContainer/VBoxContainer/Bio/Texts/SchoolAge.text = "%s - %s" % [
		player.school.short_name,
		Player.ELIGIBILITY.keys()[player.eligibility]
	]
	$MarginContainer/VBoxContainer/Bio/Texts/BodyArchetype.text = player.GetBodyStr()
	
	# physical
	SetAttribute($MarginContainer/VBoxContainer/Attributes/HBoxContainer/Left/Physical/VBoxContainer/Agility, player.agility.Get())
	SetAttribute($MarginContainer/VBoxContainer/Attributes/HBoxContainer/Left/Physical/VBoxContainer/Strength, player.strength.Get())
	SetAttribute($MarginContainer/VBoxContainer/Attributes/HBoxContainer/Left/Physical/VBoxContainer/Vertical, player.vertical_reach.Get())
	# mental
	SetAttribute($MarginContainer/VBoxContainer/Attributes/HBoxContainer/Left/Mental/VBoxContainer/Vision, player.vision.Get())
	SetAttribute($MarginContainer/VBoxContainer/Attributes/HBoxContainer/Left/Mental/VBoxContainer/OffTheBall, player.off_the_ball.Get())
	SetAttribute($MarginContainer/VBoxContainer/Attributes/HBoxContainer/Left/Mental/VBoxContainer/Positioning, player.positioning.Get())
	# technical
	SetAttribute($MarginContainer/VBoxContainer/Attributes/HBoxContainer/Right/PanelContainer/VBoxContainer/Handling, player.ball_handling.Get())
	SetAttribute($MarginContainer/VBoxContainer/Attributes/HBoxContainer/Right/PanelContainer/VBoxContainer/Finishing, player.finishing.Get())
	SetAttribute($MarginContainer/VBoxContainer/Attributes/HBoxContainer/Right/PanelContainer/VBoxContainer/Shooting, player.shooting.Get())
	SetAttribute($MarginContainer/VBoxContainer/Attributes/HBoxContainer/Right/PanelContainer/VBoxContainer/Rebounding, player.rebounding.Get())
	SetAttribute($MarginContainer/VBoxContainer/Attributes/HBoxContainer/Right/PanelContainer/VBoxContainer/Perimeter, player.perimeter_defense.Get())
	SetAttribute($MarginContainer/VBoxContainer/Attributes/HBoxContainer/Right/PanelContainer/VBoxContainer/Interior, player.interior_defense.Get())
	
	show()


func ActivateDebug():
	var p = Player.New(
				Character.New("Jared", "Butler"), 0, 12, 75, 195,
				14, 9, 6, 10,
				14, 10, 16, 17, 10, 16, 8,
				15, 18, 16,
				School.New(
					"BAY", "Baylor", "Bears"
				)
			)
	Activate(Vector2.ZERO, p)


func SetAttribute(ojw: OuterJustifyWidget, val: int):
	ojw.right = str(val)
	var colors = {
		0: ColorsUtil.ATTRIBUTE_BAD,
		4: ColorsUtil.ATTRIBUTE_MEH,
		8: ColorsUtil.ATTRIBUTE_AVG,
		12: ColorsUtil.ATTRIBUTE_GOOD,
		16: ColorsUtil.ATTRIBUTE_ELITE
	}
	
	for x in colors.keys():
		if val >= x:
			ojw.right_color = colors[x]


func _on_mouse_exited() -> void:
	hide()
