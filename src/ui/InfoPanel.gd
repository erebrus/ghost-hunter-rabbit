extends Control
signal panel_closed()


func _on_Close_pressed():
	emit_signal("panel_closed")
	visible=false
