extends RichTextLabel
class_name PlayerNameHoverableWidget


var player: Player


func Activate(p: Player):
	player = p
	text = "[url]%s[/url]" % player.character.FullName()


func _on_meta_hover_started(meta: Variant) -> void:
	if player:
		$PlayerCardWidget.Activate(player)
