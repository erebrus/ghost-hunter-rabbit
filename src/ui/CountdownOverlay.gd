extends PanelContainer

signal timeout

var time = 3
onready var countdown_label = $Countdown
func update_label():
	countdown_label.text = str(time)

func start():
	$Timer.start()
	$Tick.play()

func _on_Timer_timeout() -> void:
	if time == 0:
		return
	time -= 1
	$Tick.play()
	update_label()
	if time == 0:
		emit_signal("timeout")
		$Timer.stop()
		
	
