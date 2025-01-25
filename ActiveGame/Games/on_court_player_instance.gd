extends Sprite2D
class_name OnCourtPlayerInstance


var player: Player


@export var color1: Color:
	set(value):
		color1 = value
		self_modulate = color1

@export var color2: Color:
	set(value):
		color2 = value
		$Outline.self_modulate = color2


func Activate(_player: Player):
	player = _player
	
	color1 = player.school.color1
	color2 = player.school.color2
	
	$Number.text = str(player.jersey_number)
	$Name.text = player.character.last


func Update(location: CourtLocation):
	position = location.GetPosition()
	$Make.hide()
	$Miss.hide()


func MakeShot(points: int):
	$Make.text = "+%d" % points
	$Make.show()

func MissShot():
	$Miss.show()
