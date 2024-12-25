extends RichTextLabel
class_name PlayerNameHoverableWidget


signal name_hovered(pos: Vector2, pla: Player)


var player: Player


func Activate(p: Player):
	player = p
	text = "[url]%s[/url]" % player.character.FullName()


func _on_meta_hover_started(meta: Variant) -> void:
	name_hovered.emit(global_position, player)
