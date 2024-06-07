extends EventPage


var game: Game

# todo: separate GameProgress object that handles game logic and this just visualizes it
var time = 0


func Activate(event):
	var game_id = event.game_id
	game = Game.FromDatabase(game_id)
	
	$Content/VBoxContainer/Scoreboard/HBoxContainer/Home.text = game.home.school.id
	$Content/VBoxContainer/Scoreboard/HBoxContainer/Away.text = game.away.school.id
	$Content/VBoxContainer/HBoxContainer/Left/Team.text = game.home.school.short_name + " " + game.home.school.mascot
	$Content/VBoxContainer/HBoxContainer/Right/Team.text = game.away.school.short_name + " " + game.away.school.mascot
	
	$Content/VBoxContainer/HBoxContainer/Center/Complete.hide()
	$Content/VBoxContainer/HBoxContainer/Center/Start.show()
	
	time = 1200
	UpdateClock()
	
	show()


func UpdateClock():
	var mm = time / 60
	var ss = time % 60
	$Content/VBoxContainer/Scoreboard/HBoxContainer/Clock.text = "%d:%02d" % [mm, ss]


func _on_start_pressed():
	$Content/VBoxContainer/HBoxContainer/Center/Start.hide()
	UpdateClock()
	$Timer.start()

func _on_complete_pressed():
	event_completed.emit(self)


func _on_timer_timeout():
	time -= 30
	
	if time <= 0:
		time = 0
	UpdateClock()
	
	if time == 0:
		$Timer.stop()
		$Content/VBoxContainer/HBoxContainer/Center/Complete.show()
