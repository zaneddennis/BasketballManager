extends RichTextLabel
class_name PlayerNameHoverableWidget


var player: Player


func _on_meta_hover_started(meta: Variant) -> void:
	if player:
		$PlayerCardWidget.Activate(player)
