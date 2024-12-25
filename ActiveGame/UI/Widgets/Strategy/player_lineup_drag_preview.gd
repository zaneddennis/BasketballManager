extends Panel


func Activate(p: Player):
	$Label.text = "%s. %s" % [p.character.first[0], p.character.last]
