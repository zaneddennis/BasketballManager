extends "res://ActiveGame/UI/Pages/page.gd"


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")


func _on_desktop_pressed():
	get_tree().quit()
