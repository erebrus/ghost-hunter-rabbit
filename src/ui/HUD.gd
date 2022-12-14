extends HBoxContainer

onready var score_label = $ScoreBox/HBox/ScoreLabel
#onready var dead_score_label = $ScoreBox/HBox/DeadScoreLabel
onready var time_label = $HourglassBox/TimeLabel

	
func _process(delta):
	var time = Globals.get_world().time
	score_label.text="x %d" % Globals.get_world().score
	time_label.text = "%ds"	 % time
	if time < 5:
		time_label.set("custom_colors/font_color", Color("#d25017"))
	elif time < 10:
		time_label.set("custom_colors/font_color", Color("#edbe1f"))

