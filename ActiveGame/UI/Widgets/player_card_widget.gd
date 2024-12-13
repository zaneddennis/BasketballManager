extends PanelContainer


func _ready():
	if get_tree().current_scene == self:
		ActivateDebug()


func Activate(player: Player):
	$MarginContainer/VBoxContainer/Bio/Texts/Name.text = player.character.FullName()
	$MarginContainer/VBoxContainer/Bio/Texts/SchoolAge.text = "%s - %s" % [
		player.school.short_name,
		Player.ELIGIBILITY.keys()[player.eligibility]
	]
	$MarginContainer/VBoxContainer/Bio/Texts/BodyArchetype.text = player.GetBodyStr()
	
	# physical
	$MarginContainer/VBoxContainer/Attributes/HBoxContainer/Left/Physical/VBoxContainer/Agility.right = str(player.agility)
	$MarginContainer/VBoxContainer/Attributes/HBoxContainer/Left/Physical/VBoxContainer/Strength.right = str(player.strength)
	$MarginContainer/VBoxContainer/Attributes/HBoxContainer/Left/Physical/VBoxContainer/Vertical.right = str(player.vertical_reach)
	# mental
	$MarginContainer/VBoxContainer/Attributes/HBoxContainer/Left/Mental/VBoxContainer/Vision.right = str(player.vision)
	$MarginContainer/VBoxContainer/Attributes/HBoxContainer/Left/Mental/VBoxContainer/OffTheBall.right = str(player.off_the_ball)
	$MarginContainer/VBoxContainer/Attributes/HBoxContainer/Left/Mental/VBoxContainer/Positioning.right = str(player.positioning)
	# technical
	$MarginContainer/VBoxContainer/Attributes/HBoxContainer/Right/PanelContainer/VBoxContainer/Handling.right = str(player.ball_handling)
	$MarginContainer/VBoxContainer/Attributes/HBoxContainer/Right/PanelContainer/VBoxContainer/Finishing.right = str(player.finishing)
	$MarginContainer/VBoxContainer/Attributes/HBoxContainer/Right/PanelContainer/VBoxContainer/Shooting.right = str(player.shooting)
	$MarginContainer/VBoxContainer/Attributes/HBoxContainer/Right/PanelContainer/VBoxContainer/Rebounding.right = str(player.rebounding)
	$MarginContainer/VBoxContainer/Attributes/HBoxContainer/Right/PanelContainer/VBoxContainer/Perimeter.right = str(player.perimeter_defense)
	$MarginContainer/VBoxContainer/Attributes/HBoxContainer/Right/PanelContainer/VBoxContainer/Interior.right = str(player.interior_defense)
	
	show()


func ActivateDebug():
	var p = Player.New(
				Character.New("Jared", "Butler"), 75, 195,
				14, 9, 6,
				14, 16, 17, 10, 16, 8,
				15, 18, 16,
				School.New(
					"BAY", "Baylor", "Bears"
				)
			)
	Activate(p)
